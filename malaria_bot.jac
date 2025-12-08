import uuid;
import json;
import http;
import from datetime {datetime}
import from byllm.llm { Model }




glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=False);

# ----------------------------------------------------
# SESSION STORAGE
# ----------------------------------------------------
let sessions: dict[str, user] = {};


# ----------------------------------------------------
# USER NODE
# ----------------------------------------------------
node user {
    has session_id: str;
    has language: str = "";
    has stage: str = "greeting";
    has location: str = "";
    has symptoms: list[str] = [];
    has risk_level: str = "unknown";
    has created_at: str = "";
    has last_active: str = "";
    has payload: dict = {};
    has message: str = "";
}

node prevention{
    has language: str = "";
   


    def get_lang_name() -> str {
        if self.language == "sw" {
            return "Kiswahili";
        } else {
            return "English";
        }
    }
         
        """
        You are a friendly malaria prevention educator speaking fluently in {self.get_lang_name()}.
        Give some practical, and powerful malaria prevention tips and elaborate each tip .
        Number them 1 to 5.
        Use simple, everyday language that anyone can understand.
        End with one short encouraging sentence.
        Make it engaging and easy to remember.
        """

    def generate_tips() -> str by llm(
        method = "ReAct",
        tools = ()

    );

}
# ----------------------------------------------------
# USER WALKER – Handles sessions & routing
# ----------------------------------------------------
walker user_agent {
    has session_id: str;
    has payload: dict = {};
    has message: str = "";
    

    obj __specs__ {
        static has auth: bool = False;
    }
    can start with entry {
        # Read session id directly from walker input
        sid := self.session_id;
        if sid == None or sid == "" {
            sid := str(uuid.uuid4());
            self.session_id = sid;
        }
        now = datetime.now().isoformat();
        # Creating a new user_agent node instance and attach it
        new_user := sessions.get(sid);
        if new_user == None {
        new_user = user(
            session_id=self.session_id,
            created_at=now,
            last_active=now
                );
        here ++> new_user;
      sessions[sid] = new_user;
        } 
        else {
            new_user.last_active = now;
        }


        print("DEBUG: Session ID -> " + sid);
        report { 
            "status": "debug", 
            "step": "session_id_check", 
            "message": "Received session_id=" + sid 
        };

        print("DEBUG: Incoming message -> " + self.message); 
        new_user.message = self.message;
        print("DEBUG: Current user stage -> " + user.stage);       

        # Spawn the NLP walker and pass the me-node + message
        if user.stage.startswith("triage_") {
            print("DEBUG: User is in triage flow, spawning triage_agent");
            
            here spawn triage_agent(message=self.message);
            
        } else {
            print("DEBUG: User is NOT in triage, spawning nlp_agent");
            
            here spawn nlp_agent(message=self.message);
            disengage;
        }
    }
}


# --- NLP Walker ---
walker nlp_agent {
    #has anchor:new_user;
    has message: str;
    #has stage: str= "greeting";
    has language: str ="";

    obj __specs__ {
        static has auth: bool = False;
    }
    
    can start with entry {
        message :=user.message.strip().lower();
        print("NLP recieved message "+ self.message);
        if user.stage == "greeting" {
        response = ["Habari! Welcome to MalariaPredict AI\n\n" 
                    "Chagua lugha / Choose language:\n" 
                    "1. Kiswahili\n" 
                    "2. English"];

        report {"response": response};
        user.stage = "waiting_language";
        disengage;
       
        };

        #-------------------
        # Language Selection
        #-------------------
        if user.stage == "waiting_language" {
        
            if self.message in [ "1","kiswahili","swahili","sw" ]{
                user.language = "sw";
                response = ["Asante! Tutaendelea kwa Kiswahili.\n\n"
                             "Unaweza kuchagua:\n\n"
                           "1. Nina dalili - nisadie (triage)\n"
                           "2. Angalia hatari ya malaria sas \n"
                           "3. Tafuta hospitali ya karibu\n"
                           "4. Vidokezo vya kuzuia malaria\n"
                           "5. Toka\n\n"
                           "Andika namba 1-5"];
                report {"response": response};
            }
            elif self.message == "2" {
                user.language = "en";
                response = ["Thank you! We will continue in English.\n\n"
                            "How can I help you\n\n"
                            "1. I have symptoms - help me (triage)\n"
                            "2. Check current malaria risk\n"
                            "3. Find nearest hospital\n"
                            "4. Malaria prevention tips\n"
                            "5. Exit\n\n"
                            "Reply with a number 1-5"];
                report{"response": response};
            } 
            else {
                response = ["Tafadhali chagua lugha sahihi 1 au 2 / Please choose a valid language option 1 or 2.\n"];
                report{"response": response};
                disengage;
            };

            user.stage ="waiting_service";
            disengage;        
        };

        # Service routing
        if user.stage == "waiting_service" {
            choice := self.message.strip();

            if choice == "1" { 
                here spawn triage_agent(message=self.message);disengage;
                }
            elif choice == "2" { here spawn ml_agent(user);disengage;}
            elif choice == "3" { here spawn geo_agent(user);disengage; }
            elif choice == "4" { here spawn education_agent(user);disengage; }
            elif choice == "5" {
                if user.language == "sw" { 
                response=["Kwaheri! Kaa salama"];
                report{"response":response}; 
                } 
                else { response=["Goodbye! Stay safe"]; 
                        report{"response":response};
                }
                 
                 user.stage = "complete";
            }
            else{
                if user.language == "sw" { 
                    response=["Tafadhali andika namba 1-5"];
                    report{"response":response}; 
                    } 
                    else { 
                       response["Please reply with 1-5"]; 
                        report{"response":response};
                        };
                      
            };
            disengage;
        };
        disengage;
    }
   
}

#----------------------------------------
# Triage Agent
#----------------------------------------
walker triage_agent {
    has message: str;
    has language:str="";
    has symptoms: list[str] = [];

    can start with entry {
        print("=== TRIAGE START ===");
        print("User stage: " + user.stage);

        
        self.language = user.language;
        message := self.message.strip().lower();
        
        # Check if starting fresh
        if not user.stage.startswith("triage_") {
            print("Starting new triage");
            user.symptoms = [];  
            
            if user.language == "sw" {
                response =["Sasa nitakuuliza maswali 5 kuhusu dalili zako.\n\n"
                       "Tafadhali jibu kwa 'ndiyo' au 'hapana'.\n\n"
                       "Kisha nitakupa ushauri wa awali.\n\n"
                       "1. Je, una homa au baridi kali leo ama jana?"];
                report {"response": response};
                user.stage ="triage_fever";
            } else {
                response =["Now I will ask you 5 questions about your symptoms.\n\n"
                       "Please answer with 'yes' or 'no'.\n\n"
                       "Then I will provide preliminary advice.\n\n"
                       "1. Do you have a fever or severe chills today or yesterday?"];
                report {"response": response};
                user.stage ="triage_fever";
            }
            disengage;
        }
        
     
        if user.stage == "triage_fever" {
            print("Processing fever");
            ans := self.message.strip().lower();
            
            if ans in ["ndiyo","ndio","yes","y","1","ee","hapana","la","sio","sivyo","no","n","0"] { 
                if ans in ["yes","ndio", "ndiyo", "y","1","ee"] {
                    user.symptoms.append("fever");
                }
                
                user.stage = "triage_headache";
                
                if user.language == "sw" {
                    response =["Asante.\n\n2. Je, una maumivu makali ya kichwa?"];
                    report {"response": response};
                } else {
                    response =["Thank you.\n\n2. Do you have severe headaches?"];
                    report {"response": response};
                }
            } 
            else {
                if user.language == "sw" {
                    response =["Tafadhali jibu kwa 'ndiyo' au 'hapana'.\n\n"
                           "1. Je, una homa au baridi kali leo ama jana?"];
                    report {"response": response};
                } else {
                    response =["Please answer with 'yes' or 'no'.\n\n"
                           "1. Do you have a fever or severe chills today or yesterday?"];
                    report {"response": response};
                }
            }
            disengage;
        }
        elif user.stage == "triage_headache" {
            print("Processing headache");
            ans := self.message.strip().lower();
            
            if ans in ["ndiyo","ndio","yes","y","1","ee","hapana","la","sio","sivyo","no","n","0"] {
                if ans in ["yes","ndio", "ndiyo", "y","1","ee"] {
                    user.symptoms.append("headache");
                }
                
                user.stage = "triage_nausea";
                
                if user.language == "sw" {
                    response =["Asante.\n\n3. Je, una kichefuchefu au unatapika?"];
                    report {"response": response};
                } else {
                    response =["Thank you.\n\n3. Do you feel nauseous or are you vomiting?"];
                    report {"response": response};
                }
            } else {
                if user.language == "sw" {
                    response =["Tafadhali jibu kwa 'ndiyo' au 'hapana'.\n\n"
                           "2. Je, una maumivu makali ya kichwa?"];
                    report {"response": response};
                } else {
                    response =["Please answer with 'yes' or 'no'.\n\n"
                           "2. Do you have severe headaches?"];
                    report {"response": response};
                }
            }
            disengage;
        }
        elif user.stage == "triage_nausea" {
            print("Processing nausea");
            ans := self.message.strip().lower();
            
            if ans in ["ndiyo","ndio","yes","y","1","ee","hapana","no","n","0"] {
                if ans in ["yes","ndio", "ndiyo", "y","1","ee"] {
                    user.symptoms.append("nausea");
                }
                
                user.stage = "triage_fatigue";
                
                if user.language == "sw" {
                    response =["Asante.\n\n4. Je, una maumivu ya misuli au uchovu viungo?"];
                    report {"response": response};
                } else {
                    response =["Thank you.\n\n4. Do you have muscle or joint pain?"];
                    report {"response": response};
                }
            } else {
                if user.language == "sw" {
                    response =["Tafadhali jibu kwa 'ndiyo' au 'hapana'.\n\n"
                           "3. Je, una kichefuchefu au unatapika?"];
                    report {"response": response};
                } else {
                    response =["Please answer with 'yes' or 'no'.\n\n"
                           "3. Do you feel nauseous or are you vomiting?"];
                    report {"response": response};
                }
            }
            disengage;
        }
        elif user.stage == "triage_fatigue" {
            print("Processing fatigue - final diagnosis");
            ans := self.message.strip().lower();
            
            if ans in ["yes","ndio", "ndiyo", "y","1","ee"] {
                user.symptoms.append("fatigue");
            }
            
            # Now do final diagnosis
            fever := "fever" in user.symptoms;
            total := len(user.symptoms);
            
            print("Final symptoms: " + str(user.symptoms));
            print("Fever: " + str(fever) + ", Total: " + str(total));
            
            if user.language == "sw" {
                if fever and total >= 3 {
                    user.risk_level = "very_high";
                    response=["HATARI KUBWA SANA - MALARIA KALI INAWEZEKANA\n\n"
                        "Dalili zako zinafanana sana na malaria hatari.\n"
                        "NENDA HOSPITALI MARA MOJA - HATA USIKU WA MANANE!\n"
                        "Bila matibabu ya haraka, malaria inaweza kusababisha kifo ndani ya masaa 24.\n\n"
                        "Unataka nikutafutie hospitali ya karibu sasa hivi? (Andika 'Ndiyo')"];
                    report {"response": response};
                }
                elif fever and total >= 2 {
                    user.risk_level = "high";
                    response=["HATARI KUBWA - MALARIA INAWEZEKANA SANA\n\n"
                        "Una homa pamoja na dalili nyingine mbili au zaidi.\n"
                        "Hii ni ishara kubwa ya malaria.\n"
                        "NENDA KUPIMA NA KUPATA MATIBABU LEO HIVI.\n\n"
                        "Je, unataka nikusaidie kutafuta hospitali ya karibu? (Ndiyo/Hapana)"];
                    report {"response": response};
                }
                elif fever or total >= 3 {
                    user.risk_level = "medium";
                    response=["KUNA UWEZEKANO WA MALARIA\n\n"
                        "Dalili zako zinaweza kuwa malaria au ugonjwa mwingine.\n"
                        "USIPUUZE - nenda kupima malaria hospitalini ndani ya masaa 24.\n"
                        "Malaria inaweza kuwa mbaya ghafla bila dalili nyingi za awali.\n\n"
                        "Kinga bora: lala ndani ya chandarua kila usiku."];
                    report {"response": response};
                }
                else {
                    user.risk_level = "low";
                    response=["KWA SASA HATARI NI NDOGO\n\n"
                        "Dalili zako hazionyeshi malaria sana kwa sasa.\n"
                        "LAKINI ukipata homa, baridi, au maumivu ya kichwa ghafla - nenda hospitali mara moja.\n\n"
                        "Malaria inaweza kuanza kwa dalili ndogo tu.\n"
                        "Tumia chandarua + dawa ya mbu kila siku."];
                    report {"response": response};
                };
            } else {
                # English version
                if fever and total >= 3 {
                    user.risk_level = "very_high";
                    response=["VERY HIGH RISK - SEVERE MALARIA LIKELY\n\n"
                        "Your symptoms strongly suggest severe malaria.\n"
                        "GO TO HOSPITAL IMMEDIATELY - EVEN AT NIGHT!\n"
                        "Without urgent treatment, malaria can cause death within 24 hours.\n\n"
                        "Would you like me to find a nearby hospital for you? (Reply 'Yes')"];
                    report {"response": response};
                }
                elif fever and total >= 2 {
                    user.risk_level = "high";
                    response=["HIGH RISK - MALARIA VERY LIKELY\n\n"
                        "You have a fever with two or more other symptoms.\n" 
                        "This is a strong sign of malaria.\n"
                        "GET TESTED AND TREATED TODAY.\n\n"
                        "Do you want help finding a nearby hospital? (Yes/No)"];
                    report {"response": response};
                }
                elif fever or total >= 3 {  
                    user.risk_level = "medium";
                    response=["POSSIBLE MALARIA\n\n"
                        "Your symptoms could be malaria or another illness.\n"
                        "DON'T IGNORE IT - get tested within 24 hours.\n"
                        "Malaria can worsen suddenly without many early symptoms.\n\n"
                        "Best prevention: sleep under a mosquito net every night."];
                    report {"response": response};
                }
                else {
                    user.risk_level = "low";
                    response=["LOW RISK FOR NOW\n\n"
                        "Your symptoms don't strongly suggest malaria right now.\n"
                        "BUT if you develop fever, chills, or severe headaches suddenly - go to hospital immediately.\n\n"
                        "Malaria can start with very few symptoms.\n"
                        "Use mosquito nets + repellents daily."];
                    report {"response": response};
                };
            }
            user.stage = "triage_complete";
            disengage;
        }
             
    }
}

walker education_agent{
    has user: user;
    has tips:str = "";
    has language: str = "";

    obj __specs__ {
        static has auth: bool = False;
    }
     can start with entry {
    self.language = user.language;
    print("DEBUG: User language for education_agent: " + self.language);
    prevent= (here ++> prevention(self.language))[0];
    self.tips = prevent.generate_tips();
    response = self.tips.strip().split("\n");
    report {"response": response};
        
        #Fallback to default tips if LLM fails
        if not response {
        if lang == "sw" {
            response = ["Vidokezo vya kuzuia malaria:\n\n"
                        "1. Lala ndani ya chandarua kilichotiwa dawa kila usiku.\n"
                        "2. Tumia dawa ya kuzuia mbu mwilini kila siku.\n"
                        "3. Epuka maeneo yenye mbu hasa asubuhi na jioni.\n"
                        "4. Fanya usafi wa mazingira karibu na nyumba yako.\n"
                        "5. Pima malaria mara kwa mara, hasa kama una dalili.\n\n"
                        ];
        } else {
            response = ["Malaria prevention tips:\n\n"
                        "1. Sleep under an insecticide-treated mosquito net every night.\n"
                        "2. Use mosquito repellent on your skin daily.\n"
                        "3. Avoid areas with mosquitoes, especially early morning and evening.\n"
                        "4. Keep your surroundings clean and free of standing water.\n"
                        "5. Get tested for malaria regularly, especially if you have symptoms.\n\n"
                        ];
        }
        report {"response": response};
        disengage;
    }
    }
}


# ----------------------------------------------------
# GEO AGENT – Handles location-based services
# ----------------------------------------------------
walker geo_agent {
    has user: user;


    can start with entry {
        print("DEBUG: User location for geo_agent: " + user.location);
        #getting user location
        location := user.location.strip().lower();
        
        if user.location == "" {
            if user.language == "sw" {
                response = ["Tafadhali andika eneo lako la sasa (mfano:Kisumu, Nairobi, Homa Bay,Migori.....)"];
                report {"response": response};
            } else {
                response = ["Please provide your current location (e.g. Kisumu, Nairobi, Homa Bay, Migori...)"];
                report {"response": response};
            }
            disengage;
        } 

        api_key := "";

        #convert location to coordinates
        geocode_url :="https://maps.googleapis.com/maps/api/geocode/json?address=" +
                       location.urlencode() + "&key=" + api_key;
        
        geo_result := http.get(geocode_url);

        if geo_result.status_code != 200 {
            if user.language == "sw" {
                response = ["Samahani, hatuwezi kupata eneo lako. Tafadhali hakikisha umeandika jina sahihi la eneo."];
                report {"response": response};
            } else {
                response = ["Sorry, we couldn't find your location. Please make sure you entered a valid place name."];
                report {"response": response};
            }
            user.stage = "waiting_service";
            here spawn nlp_agent(user);
            disengage;
        }

        lat := geo_result.json()["results"][0]["geometry"]["location"]["lat"];
        lng := geo_result.json()["results"][0]["geometry"]["location"]["lng"];

        #searching hospitals around
        places_url :="https://maps.googleapis.com/maps/api/place/nearbysearch/json" +
                      "?location=" + str(lat) + "," + str(lng) +
                      "&radius=10000" +
                      "&type=hospital" +
                      "&keyword=hospital|clinic|dispensary" +
                      "&key=" + api_key;

        result := http.get(places_url);

        if result.status_code != 200 {
            if user.language == "sw" {
                response = ["Samahani, hatuwezi kupata hospitali karibu nawe. Nenda hospitali ya karibu nawe."];
                report {"response": response};
            } else {
                response = ["Sorry, we couldn't find any hospitals near you. Please go to the nearest health facility."];
                report {"response": response};
            }
            user.stage = "waiting_service";
            here spawn nlp_agent(user);
            disengage;
        }

        hospitals := result.json()["results"][:3];

        if user.language == "sw" {
            response = ["Hospitali 3 za karibu na '{loc}':\n".format(loc=location)];
            report {"response": response};
        } else {
            response = ["Top 3 hospitals near '{loc}':\n".format(loc=location)];
            report {"response": response};
        }

               count := 0;
        while count < 3 and count < hospitals.length {
            h := hospitals[count];
            name := h["name"];
            addr := "No address";
            if "vicinity" in h { addr := h["vicinity"]; }

            rating := "";
            if "rating" in h { rating := " (" + str(h["rating"]) + "/5.0)"; }

            h_lat := h["geometry"]["location"]["lat"];
            h_lng := h["geometry"]["location"]["lng"];
            link := "https://maps.google.com/?q=" + str(h_lat) + "," + str(h_lng);

            response =[str(count+1) + ". " + name + "\n   " + addr + rating + "\n   Mwelekeo: " + link + "\n"];
            report {"response": response};

            count = count + 1; 
        }

        if user.language == "sw"{
            response =["\nBofya link ya hospitali unayotaka kuenda.\n Kurudi menyu andika 'menu'"];
            report {"response": response};  
        } else {
               response =["\nClick on the hospital link you want to go to.\n To return to the menu, type 'menu'"];
                report {"response": response};    
        }
        #return to main menu
        user.stage = "waiting_service";
        here spawn nlp_agent(user);
        disengage;

    }
}



walker root {
    has session_id: str;
    has message: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can start with `root entry {

            here spawn user_agent(
                session_id=self.session_id, 
                message=self.message
            );
       
        }
    }












