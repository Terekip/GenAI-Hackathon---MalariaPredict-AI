
import os;
import uuid;
import json;
import http;
import urllib;
import from datetime {datetime}
import from byllm.lib { Model }
import litellm;
import from dotenv {load_dotenv}

# Enable debug mode (add this line)
#litellm._turn_on_debug()

#glob llm = Model(model_name="gpt-4o");
#glob llm = Model(model_name="gemini/gemini-2.0-flash", verbose=True);
glob llm = Model(model_name="groq/llama3-8b-8192", verbose=True);
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
    has history: list[str] = [];
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
        


    def generate_tips() -> str by llm(
        method = "ReAct",
        tools = (),
        prompt =        """
        You are a friendly malaria prevention educator speaking fluently in {self.get_lang_name()}.
        Give some practical, and powerful malaria prevention tips and elaborate each tip .
        Number them 1 to 3.
        Use simple, everyday language that anyone can understand.
        End with one short encouraging sentence.
        Make it engaging and easy to remember.
        """

    );


}

#-----------------------------------------------------
# Geo Node
#-----------------------------------------------------
node geoagent {
    has location: str;
    has language: str = "";  # default
    has response_lines: str=[];

    def find_hospitals() -> str {
        print("DEBUG: finding hospitals in "+" " + self.location + " " + self.language);

        # Normalize location
        loc = self.location.strip().lower();

        # Geocode with Nominatim using http.client
        conn = http.client.HTTPSConnection("nominatim.openstreetmap.org");
        headers = {"User-Agent": "MalariaPredictAI/1.0 (teretich92@gmail.com)"};
        path = "/search?q=" + loc + "&format=json&limit=1";

        conn.request("GET", path, headers=headers);
        geo_response = conn.getresponse();
        

        print("Geocode status: " + str(geo_response.status));

        if geo_response.status != 200 {
            print("Geocode failed");
            conn.close();
            print("Debug:Geo response:" + geo_response);
            
        }

        geo_data = geo_response.read().decode("utf-8");
        conn.close();

        geo_json = json.loads(geo_data);
        print("DEBUG: Geocode JSON length: " + str(len(geo_json)));


        lat = geo_json[0]["lat"];
        lng = geo_json[0]["lon"];
        print("Coordinates: " + str(lat) + ", " + str(lng));

        # Overpass API using http.client (POST)
        overpass_query = """
        [out:json];
        (
          node["amenity"~"hospital|clinic"](around:10000,{lat},{lng});
          way["amenity"~"hospital|clinic"](around:10000,{lat},{lng});
          relation["amenity"~"hospital|clinic"](around:10000,{lat},{lng});
        );
        out center 5;
        """.format(lat=lat, lng=lng);
        
        body = urllib.parse.urlencode({"data": overpass_query});
        #body = "data=" + overpass_query;

        conn2 = http.client.HTTPSConnection("overpass.kumi.systems");
        headers2 = {"Content-Type": "application/x-www-form-urlencoded"};

        conn2.request("POST", "/api/interpreter", body=body, headers=headers2);
        overpass_response = conn2.getresponse();

        print("Overpass status: " + str(overpass_response.status));

        if overpass_response.status != 200 {
            print("Overpass failed");
            conn2.close();
            
        }

        overpass_data = overpass_response.read().decode("utf-8");
        conn2.close();
        print("overpass_data:"+ overpass_data);

        result_json = json.loads(overpass_data);
        print("debug:Result json:" , result_json);
        elements = result_json["elements"];
        print("elements:"+ json.dumps(elements, indent=2));
        elements_list = [];
        for elem in elements {
            elements_list.append(elem);
            }
        elements_count= len(elements_list);
        
        print("DEBUG: Elements count = " + str(elements_count));
        response_lines = [];

        city_name = loc.capitalize();
        print("DEBUG:city_name:" + city_name);

        if user.language == "sw" {
            response_lines.append("Hospitali karibu na '" + city_name + "':\n");
        } else {
            response_lines.append("Facilities near '" + city_name + "':\n");
        }
        
         print("Debug:Here");
        if elements_count == 0 {
            print("Has started");
            if user.language == "sw" {
                response_lines.append("Hakuna hospitali iliyopatikana karibu.");
                print("Debug:" + response_lines);
            } else {
                response_lines.append("No hospitals found nearby.");
                print("Debug:" + response_lines);
            }
            print("DEBUG: No hospitals found");
        } else {
            print("Has started");
            count = 0;
            while count < elements_count and count < 5 {
                elem = elements_list[count];

                name = "Unnamed facility";
                if "tags" in elem and "name" in elem["tags"] {
                    name = elem["tags"]["name"];
                }
                print("Its going well");

                lat_c = elem.get("lat", 0);
                lon_c = elem.get("lon", 0);
                print("Keep going");


                link = "https://maps.google.com/?q=" + str(lat_c) + "," + str(lon_c);

                line = str(count + 1) + ". " + name + "\n   Mwelekeo: " + link + "\n";
                response_lines.append(line);

                count += 1;
            }
            print("completed:" + str(response_lines));

            if user.language == "sw" {
                response_lines.append("\nBofya linki ya hospitali unayotaka kwenda.\nAndika 'menu' kurudi.");
            } else {
                response_lines.append("\nClick the hospital link you want to visit.\n Type 'menu' to return.");
            }
            print("DEBUG: Successfully built list with " + str(response_lines) + " lines");
             
        }
         #print("Debug:" + response_lines);
        # Final report — always runs, whether hospitals found or not
        return response_lines;
        
    }
   
}

#-----------------------------------
# Prediction Node
#-----------------------------------

    

# ----------------------------------------------------
# USER WALKER – Handles sessions & routing
# ----------------------------------------------------
walker user_agent {
    has session_id: str;
    has payload: dict = {};
    has message: str = "";
    has history: list[str] = [];

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

        print("DEBUG: Incoming message -> " + self.message); 
        new_user.message = self.message;
        print("DEBUG: Current user stage -> " + user.stage);       

        # Spawn the NLP walker and pass the me-node + message
        if user.stage.startswith("triage_") {
            print("DEBUG: User is in triage flow, spawning triage_agent");
            
            here spawn triage_agent(message=self.message); 

        }elif user.stage.startswith("finding_"){
            print("DEBUG:user in find_hospitals");
            user.location = self.message.strip();
            here spawn geo_agent(user);
        }
          else {
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
    has history: list[str] = [];

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
        
        
        report {"response": [response]};

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
        print("=== education START ===");
    self.language = user.language;
    print("DEBUG: User language for education_agent: " + self.language);
    prevent= (here ++> prevention(self.language))[0];
    print("debug: prevention has started!");
    self.tips = prevent.generate_tips();
    print("DEBUG: Raw LLM response:\n" + self.tips);
    response = self.tips.strip().split("\n"); 
    report {"response": response};
        

    }
    }



# ----------------------------------------------------
# GEO AGENT – Handles location-based services
# ----------------------------------------------------
walker geo_agent {
    has user: user;
    has location: str="";
    has language:str="";
    has response_lines: str=[];


can start with entry {
    print("=== geo_agent START ===");
    print("DEBUG: User location for geo_agent: " + user.location);

    location = user.location.strip().lower();
    user.stage="finding_hospitals";

    if location == "" {
        if user.language == "sw" {
            response = ["Tafadhali andika eneo lako la sasa (mfano: Kisumu, Nairobi, Homa Bay, Migori...)"];
            report {"response": response};
            
        } else {
            response = ["Please provide your current location (e.g. Kisumu, Nairobi, Homa Bay, Migori...)"];
        }
        report {"response": response};
        disengage;
    }

    # Spawn the GeoAgent node (reusable logic)
    geo = (here ++> geoagent(location=location,language=user.language))[0];
    print("DEBUG: Geoagent node created successfully: " + str(geo));
    result =geo.find_hospitals();
    print("Debug: results = " + json.dumps(result));
    #results = { "response": result };

    #response = result.strip.join("\n");
    #report {"response": results};
    report {"response":result };

    # Return to main menu
    user.stage = "waiting_service";
    here spawn nlp_agent(user);
    disengage;
}
}



walker root_walker {
    has session_id: str;
    has message: str;

    obj __specs__ {
        static has auth: bool = False;
    }

    can start with entry {

            here spawn user_agent(
                session_id=self.session_id, 
                message=self.message
            );
       
        }
    }




# app.jac - CORRECTED using official syntax
cl import from react { useState, useEffect,useRef }


cl {
    
    import from "@jac-client/utils" {
        Router,
        Routes,
        Route,
        Link,
        Navigate,
        useNavigate,
        jacSignup,
        jacLogin,
        jacLogout,
        jacIsLoggedIn
    }

    # Your existing MessageBubble — unchanged
    def MessageBubble(msg: dict, index: int) -> any {
        if not msg or not msg.text or msg.text == "undefined" {
            return <div key={index} style={{"display": "none"}}></div>;
        }
        displayText = "";
        if type(msg.text) == "string" {
            displayText = msg.text;
        } elif msg.text and type(msg.text) == "object" and "response" in msg.text {
            responseArray = msg.text["response"];
            if type(responseArray) == "array" and len(responseArray) > 0 {
                displayText = responseArray.join("\n");
            } else {
                displayText = "Invalid response";
            }
        } else {
            displayText = "" + msg.text;
        }

        if msg.sender == "bot" {
            return <div key={index} style={{
                "margin": "8px auto 8px 0",
                "padding": "12px 16px",
                "borderRadius": "18px 18px 4px 18px",
                "maxWidth": "75%",
                "width": "fit-content",
                "background": "#333",
                "color": "#fff",
                "textAlign": "left",
                "whiteSpace": "pre-line",
                "wordWrap": "break-word",
                "boxShadow": "0 2px 5px rgba(0,0,0,0.1)"
            }}>
                {displayText}
            </div>;
        } else {
            return <div key={index} style={{
                "margin": "8px 0 8px auto",
                "padding": "12px 16px",
                "borderRadius": "18px 18px 18px 4px",
                "maxWidth": "75%",
                "width": "fit-content",
                "background": "#515964ff",
                "color": "#fff",
                "textAlign": "left",
                "whiteSpace": "pre-line",
                "wordWrap": "break-word",
                "boxShadow": "0 2px 5px rgba(0,0,0,0.1)"
            }}>
                {displayText}
            </div>;
        }
    }

    # Navigation Bar
    def Navigation() -> any {
        isLoggedIn = jacIsLoggedIn();
        navigate = useNavigate();

        def handleLogout() -> None {
            jacLogout();
            navigate("/");
        }

        return <nav style={{
            "padding": "16px 32px",
            "background": "#1a5fb4",
            "color": "white",
            "display": "flex",
            "justifyContent": "space-between",
            "alignItems": "center",
            "fontFamily": "system-ui, sans-serif",
            "boxShadow": "0 2px 10px rgba(0,0,0,0.1)"
        }}>
            <div style={{"fontSize": "1.6em", "fontWeight": "700"}}>
                🦟 MalariaPredict AI
            </div>

            {isLoggedIn && 
                <button
                    onClick={handleLogout}
                    style={{
                        "background": "transparent",
                        "color": "white",
                        "border": "2px solid white",
                        "padding": "8px 20px",
                        "borderRadius": "30px",
                        "cursor": "pointer",
                        "fontWeight": "600"
                    }}
                >
                    Logout
                </button>
            }

            {isLoggedIn == false  && 
                <div style={{"display": "flex", "gap": "20px"}}>
                    <Link to="/login" style={{"color": "white", "textDecoration": "none", "fontSize": "1.1em"}}>
                        Login
                    </Link>
                    <Link to="/signup" style={{"color": "white", "textDecoration": "none", "fontSize": "1.1em"}}>
                        Sign Up
                    </Link>
                </div>
            }
        </nav>;
    }

    # Beautiful Landing Page (when not logged in)
# Enhanced MalariaPredict AI Landing Page (Button-Free)
def LandingPage() -> any {
    if (jacIsLoggedIn()) {
        return <Navigate to="/chat" />;
    }

    return <div style={{
        "minHeight": "100vh",
        "background": "linear-gradient(rgba(15,23,42,0.4), rgba(24, 34, 54, 0.6)), url('https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed",
        "display": "flex",
        "flexDirection": "column",
        "alignItems": "center",
        "justifyContent": "center",
        "color": "#f8fafc",
        "textAlign": "center",
        "padding": "20px 15px",  # Even tighter
        "fontFamily": "'Inter', system-ui, sans-serif"
    }}>
        # Logo & Header — smaller
        <div style={{"marginBottom": "15px"}}>
            <div style={{
                "fontSize": "3em",  # Reduced from 5.5em → 3em
                "margin": "0 0 6px 0",
                "fontWeight": "900",
                "background": "linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%)",
                "backgroundClip": "text",
                "WebkitBackgroundClip": "text",
                "color": "transparent",
                "letterSpacing": "-0.5px"
            }}>
                🦟 MalariaPredict AI
            </div>
            <div style={{"color": "#cbd5e1", "fontSize": "0.9em"}}>
                Advanced AI-Powered Malaria Detection System
            </div>
        </div>

        # Hero Tagline — fixed + smaller
        <h1 style={{
            "fontSize": "1.8em",  # Reduced from 3.2em → 1.8em
            "margin": "0 0 15px 0",
            "fontWeight": "700",
            "maxWidth": "700px",
            "lineHeight": "1.2"
        }}>
            {"Early Detection • Faster Action • "}
            <span style={{"color": "#60a5fa"}}>Lives Saved</span>
        </h1>

        # Main Description — shorter
        <p style={{
            "fontSize": "1em",  # Reduced
            "maxWidth": "650px",
            "margin": "0 0 25px 0",
            "opacity": 0.95,
            "lineHeight": "1.5",
            "color": "#c7d8eeff"
        }}>
            Bilingual AI companion for instant malaria symptom assessment, risk analysis, hospital finder, and prevention tips.
        </p>

        # Login Prompt — compact
        <div style={{
            "margin": "0 0 30px 0",
            "padding": "15px 25px",
            "background": "rgba(30, 41, 59, 0.7)",
            "borderRadius": "12px",
            "border": "1px solid rgba(100, 116, 139, 0.3)",
            "maxWidth": "600px"
        }}>
            <p style={{
                "fontSize": "1em",
                "margin": "0 0 10px 0",
                "color": "#60a5fa",
                "fontWeight": "600"
            }}>
                Ready to get started?
            </p>
            <p style={{"margin": 0, "opacity": 0.9, "fontSize": "0.9em"}}>
                Log in or sign up to begin your personalized malaria health journey.
            </p>
        </div>

        # Features Grid — super compact
        <div style={{
            "display": "grid",
            "gridTemplateColumns": "repeat(auto-fit, minmax(180px, 1fr))",
            "gap": "15px",
            "maxWidth": "900px",
            "margin": "0 0 30px 0",
            "padding": "20px",
            "background": "rgba(30, 41, 59, 0.6)",
            "borderRadius": "16px"
        }}>
            <div style={{"padding": "10px"}}>
                <div style={{"fontSize": "1.8em", "marginBottom": "8px"}}>🤖</div>
                <h3 style={{"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}>AI Symptom Triage</h3>
                <p style={{"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}>Bilingual assessment in English & Kiswahili</p>
            </div>
            <div style={{"padding": "10px"}}>
                <div style={{"fontSize": "1.8em", "marginBottom": "8px"}}>📊</div>
                <h3 style={{"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}>Risk Assessment</h3>
                <p style={{"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}>Personalized risk scoring</p>
            </div>
            <div style={{"padding": "10px"}}>
                <div style={{"fontSize": "1.8em", "marginBottom": "8px"}}>🏥</div>
                <h3 style={{"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}>Hospital Finder</h3>
                <p style={{"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}>Nearest malaria treatment centers</p>
            </div>
            <div style={{"padding": "10px"}}>
                <div style={{"fontSize": "1.8em", "marginBottom": "8px"}}>🛡️</div>
                <h3 style={{"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}>Prevention Tips</h3>
                <p style={{"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}>AI-generated strategies</p>
            </div>
        </div>

        # Stats Bar — very compact
        <div style={{
            "display": "flex",
            "gap": "30px",
            "marginBottom": "30px",
            "flexWrap": "wrap",
            "justifyContent": "center"
        }}>
            <div style={{"textAlign": "center"}}>
                <div style={{"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}>95%</div>
                <div style={{"fontSize": "0.8em", "opacity": 0.8}}>Detection Accuracy</div>
            </div>
            <div style={{"textAlign": "center"}}>
                <div style={{"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}>24/7</div>
                <div style={{"fontSize": "0.8em", "opacity": 0.8}}>Availability</div>
            </div>
            <div style={{"textAlign": "center"}}>
                <div style={{"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}>2 min</div>
                <div style={{"fontSize": "0.8em", "opacity": 0.8}}>Average Assessment</div>
            </div>
            <div style={{"textAlign": "center"}}>
                <div style={{"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}>10k+</div>
                <div style={{"fontSize": "0.8em", "opacity": 0.8}}>Users Helped</div>
            </div>
        </div>

        # Motto & Footer — minimal
        <div style={{"paddingTop": "20px", "maxWidth": "600px"}}>
            <p style={{
                "fontSize": "1em",
                "fontWeight": "600",
                "margin": "0 0 10px 0",
                "fontStyle": "italic",
                "color": "#cbd5e1"
            }}>
                Know sooner. Act faster. End malaria together.
            </p>
            <p style={{"fontSize": "0.8em", "opacity": 0.7, "margin": 0}}>
                © 2025 MalariaPredict AI
            </p>
        </div>
    </div>;
}
    # Login Page
    def LoginPage() -> any {
        if (jacIsLoggedIn()) {
            return <Navigate to="/chat" />;
        }

        [email, setEmail] = useState("");
        [password, setPassword] = useState("");
        [error, setError] = useState("");
        navigate = useNavigate();

        async def handleLogin(e: any) -> None {
            e.preventDefault();
            setError("");
            success = await jacLogin(email, password);
            if (success) {
                navigate("/chat");
            } else {
                setError("Invalid email or password");
            }
        }

        return <div style={{
            "minHeight": "100vh",
            "background": "#0f172a",
            "display": "flex",
            "alignItems": "center",
            "justifyContent": "center",
            "padding": "20px"
        }}>
            <div style={{
                "background": "#1e293b",
                "padding": "40px",
                "borderRadius": "20px",
                "width": "100%",
                "maxWidth": "400px",
                "boxShadow": "0 10px 30px rgba(0,0,0,0.3)"
            }}>
                <h2 style={{"textAlign": "center", "marginBottom": "30px", "color": "#1a5fb4"}}>
                    Login
                </h2>
                <form onSubmit={handleLogin}>
                    <input
                        type="email"
                        value={email}
                        onChange={lambda e: any -> None { setEmail(e.target.value); }}
                        placeholder="Email"
                        required
                        style={{
                            "width": "100%",
                            "padding": "14px",
                            "marginBottom": "16px",
                            "borderRadius": "12px",
                            "border": "none",
                            "background": "#334155",
                            "color": "white",
                            "fontSize": "16px"
                        }}
                    />
                    <input
                        type="password"
                        value={password}
                        onChange={lambda e: any -> None { setPassword(e.target.value); }}
                        placeholder="Password"
                        required
                        style={{
                            "width": "100%",
                            "padding": "14px",
                            "marginBottom": "20px",
                            "borderRadius": "12px",
                            "border": "none",
                            "background": "#334155",
                            "color": "white",
                            "fontSize": "16px"
                        }}
                    />
                    {error && <p style={{"color": "#ef4444", "textAlign": "center", "marginBottom": "16px"}}>{error}</p>}
                    <button
                        type="submit"
                        style={{
                            "width": "100%",
                            "padding": "16px",
                            "background": "#1a5fb4",
                            "color": "white",
                            "border": "none",
                            "borderRadius": "12px",
                            "fontSize": "1.1em",
                            "fontWeight": "600",
                            "cursor": "pointer"
                        }}
                    >
                        Login
                    </button>
                </form>
                <p style={{"textAlign": "center", "marginTop": "24px", "color": "#94a3b8"}}>
                    Don't have an account? <Link to="/signup" style={{"color": "#1a5fb4"}}>Sign Up</Link>
                </p>
            </div>
        </div>;
    }

    # Signup Page
    def SignupPage() -> any {
        if jacIsLoggedIn() {
            return <Navigate to="/chat" />;
        }

        [email, setEmail] = useState("");
        [password, setPassword] = useState("");
        [error, setError] = useState("");
        navigate = useNavigate();

        async def handleSignup(e: any) -> None {
            e.preventDefault();
            setError("");
            result = await jacSignup(email, password);
            if (result["success"]) {
                navigate("/chat");
            } else {
                setError(result["error"] || "Signup failed");
            }
        }

        return <div style={{
            "minHeight": "100vh",
            "background": "#0f172a",
            "display": "flex",
            "alignItems": "center",
            "justifyContent": "center",
            "padding": "20px"
        }}>
            <div style={{
                "background": "#1e293b",
                "padding": "40px",
                "borderRadius": "20px",
                "width": "100%",
                "maxWidth": "400px",
                "boxShadow": "0 10px 30px rgba(0,0,0,0.3)"
            }}>
                <h2 style={{"textAlign": "center", "marginBottom": "30px", "color": "#1a5fb4"}}>
                    Sign Up
                </h2>
                <form onSubmit={handleSignup}>
                    <input
                        type="email"
                        value={email}
                        onChange={lambda e: any -> None { setEmail(e.target.value); }}
                        placeholder="Email"
                        required
                        style={{
                            "width": "100%",
                            "padding": "14px",
                            "marginBottom": "16px",
                            "borderRadius": "12px",
                            "border": "none",
                            "background": "#334155",
                            "color": "white",
                            "fontSize": "16px"
                        }}
                    />
                    <input
                        type="password"
                        value={password}
                        onChange={lambda e: any -> None { setPassword(e.target.value); }}
                        placeholder="Password"
                        required
                        style={{
                            "width": "100%",
                            "padding": "14px",
                            "marginBottom": "20px",
                            "borderRadius": "12px",
                            "border": "none",
                            "background": "#334155",
                            "color": "white",
                            "fontSize": "16px"
                        }}
                    />
                    {error && <p style={{"color": "#ef4444", "textAlign": "center", "marginBottom": "16px"}}>{error}</p>}
                    <button
                        type="submit"
                        style={{
                            "width": "100%",
                            "padding": "16px",
                            "background": "#1a5fb4",
                            "color": "white",
                            "border": "none",
                            "borderRadius": "12px",
                            "fontSize": "1.1em",
                            "fontWeight": "600",
                            "cursor": "pointer"
                        }}
                    >
                        Sign Up
                    </button>
                </form>
                <p style={{"textAlign": "center", "marginTop": "24px", "color": "#94a3b8"}}>
                    Already have an account? <Link to="/login" style={{"color": "#1a5fb4"}}>Login</Link>
                </p>
            </div>
        </div>;
    }

    # Your main chat page — protected
    def ChatPage() -> any {
        if not jacIsLoggedIn() {
            return <Navigate to="/" />;
        }

        [messages, setMessages] = useState([]);
        [input, setInput] = useState("");
        [loading, setLoading] = useState(false);
        chatScrollRef = useRef(null);
        [sessionId, _] = useState(lambda -> str {
        return "sess_" + crypto.randomUUID();  # e.g., sess_b2d188bb-c039-4359-b595-be1bdee732c0
    });

        useEffect(lambda -> None {
            sendMessage("");
        }, []);

        useEffect(lambda -> None {
            if (chatScrollRef.current) {
                chatScrollRef.current.scrollTop = chatScrollRef.current.scrollHeight;
            }
        }, [messages, loading]);

        async def sendMessage(text: str) -> None {
            currentInput = input.trim();
            if not currentInput {
                return;
            }
            messageText = currentInput;
            setInput("");
            setLoading(true);

            currentMessages = messages;

            setMessages(currentMessages.concat([{"sender": "user", "text": messageText}]));

            result = root spawn root_walker(
                message=messageText, 
                session_id=sessionId
            );

            bot_reply = "No response from bot";

            if result && result.reports && result.reports.length > 0 {
                
                response = result.reports[0]["response"];
                bot_reply = response;#.join("\n");
                console.log("result:" + result);
                console.log("result_report:" + result.reports);
                console.log(result.reports[0]["response"]);
            }


            setMessages(currentMessages.concat([ 
                {"sender": "user", "text": messageText},
                {"sender": "bot", "text": bot_reply}]
            ));

            setLoading(false);   
        }

        def handleKeyPress(event: any) -> None {
            if event.key == "Enter" {
                sendMessage();
            }
        }

        return <div style={{"height":"100vh","display":"flex","flexDirection":"column","background":"#0f172a","color":"#f0f0f0"}}>
            <div style={{"background":"#1a5fb4","padding":"20px","textAlign":"center"}}>
                <h2 style={{"margin":"0","fontSize":"1.8em"}}>🦟 MalariaPredict AI</h2>
                <p style={{"margin":"8px 0 0","fontSize":"1.1em","opacity":0.9}}>
                  Bilingual symptom checker • Risk assessment • Nearest hospitals • Prevention tips
                </p>
                <p style={{"margin":"4px 0 0","fontStyle":"italic","opacity":0.8}}>
                    <strong>Motto:</strong> Know sooner. Act faster. End malaria together.
                </p>
            </div>

            <div ref={chatScrollRef} style={{"flex":1,"overflowY":"auto","padding":"15px","display":"flex","flexDirection":"column"}}>
                {messages.map(MessageBubble)}
                {loading && <div style={{"color":"#aaa","fontStyle":"italic"}}>Thinking...</div>}
            </div>

            <div style={{"padding":"20px","background":"#111","display":"flex","gap":"10px"}}>
                <input value={input} 
                       onChange={lambda e: any -> None { setInput(e.target.value); }}
                       onKeyPress={lambda e: any -> None { if(e.key=="Enter") {sendMessage(input); }}}
                       placeholder="Type here..." 
                       style={{"flex":1,"padding":"16px","borderRadius":"30px","border":"none","background":"#1e293b","color":"white","fontSize":"16px"}} />
                <button onClick={lambda -> None { sendMessage(input); }}
                        style={{"background":"#1a5fb4","color":"white","border":"none","borderRadius":"30px","padding":"0 30px"}}>Send</button>
            </div>
            <div style={{
                "marginTop": "32px",
                "paddingBottom": "24px",
                "textAlign": "center",
                "color": "rgba(240, 240, 240, 0.6)",
                "fontSize": "0.95rem",
                "fontWeight": "500"
            }}>
                ⚡ Built with Jaseci Stack
            </div>
        </div>;
    }

    # Main App Router
    def app() -> any {
        return <Router>
            <Navigation />
            <Routes>
                <Route path="/" element={<LandingPage />} />
                <Route path="/login" element={<LoginPage />} />
                <Route path="/signup" element={<SignupPage />} />
                <Route path="/chat" element={<ChatPage />} />
                <Route path="*" element={<Navigate to="/" />} />
            </Routes>
        </Router>;
    }
}


with entry{
    load_dotenv();
    GEMINI_API_KEY = os.getenv("GEMINI_API_KEY");

}


