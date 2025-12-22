import {__jacJsx, __jacSpawn} from "@jac-client/utils";
import { useState, useEffect, useRef } from "react";
import { Router, Routes, Route, Link, Navigate, useNavigate, jacSignup, jacLogin, jacLogout, jacIsLoggedIn } from "@jac-client/utils";
function MessageBubble(msg, index) {
  if (!msg || !msg.text || msg.text === "undefined") {
    return __jacJsx("div", {"key": index, "style": {"display": "none"}}, []);
  }
  let displayText = "";
  if (typeof msg.text === "string") {
    displayText = msg.text;
  } else if (msg.text && typeof msg.text === "object" && "response" in msg.text) {
    let responseArray = msg.text["response"];
    if (typeof responseArray === "array" && len(responseArray) > 0) {
      displayText = responseArray.join("\\n");
    } else {
      displayText = "Invalid response";
    }
  } else {
    displayText = "" + msg.text;
    console.log("TYPE:", typeof msg.text["response"]);
    console.log("VALUE:", msg.text["response"]);
  }
  if (msg.sender === "bot") {
    return __jacJsx("div", {"key": index, "style": {"margin": "8px auto 8px 0", "padding": "12px 16px", "borderRadius": "18px 18px 4px 18px", "maxWidth": "75%", "width": "fit-content", "background": "#333", "color": "#fff", "textAlign": "left", "whiteSpace": "pre-line", "wordWrap": "break-word", "boxShadow": "0 2px 5px rgba(0,0,0,0.1)"}}, [displayText]);
  } else {
    return __jacJsx("div", {"key": index, "style": {"margin": "8px 0 8px auto", "padding": "12px 16px", "borderRadius": "18px 18px 18px 4px", "maxWidth": "75%", "width": "fit-content", "background": "#515964ff", "color": "#fff", "textAlign": "left", "whiteSpace": "pre-line", "wordWrap": "break-word", "boxShadow": "0 2px 5px rgba(0,0,0,0.1)"}}, [displayText]);
  }
}
function Navigation() {
  let isLoggedIn = jacIsLoggedIn();
  let navigate = useNavigate();
  function handleLogout() {
    jacLogout();
    navigate("/");
  }
  return __jacJsx("nav", {"style": {"padding": "16px 32px", "background": "#1a5fb4", "color": "white", "display": "flex", "justifyContent": "space-between", "alignItems": "center", "fontFamily": "system-ui, sans-serif", "boxShadow": "0 2px 10px rgba(0,0,0,0.1)"}}, [__jacJsx("div", {"style": {"fontSize": "1.6em", "fontWeight": "700"}}, ["🦟 MalariaPredict AI"]), isLoggedIn && __jacJsx("button", {"onClick": handleLogout, "style": {"background": "transparent", "color": "white", "border": "2px solid white", "padding": "8px 20px", "borderRadius": "30px", "cursor": "pointer", "fontWeight": "600"}}, ["Logout"]), isLoggedIn === false && __jacJsx("div", {"style": {"display": "flex", "gap": "20px"}}, [__jacJsx(Link, {"to": "/login", "style": {"color": "white", "textDecoration": "none", "fontSize": "1.1em"}}, ["Login"]), __jacJsx(Link, {"to": "/signup", "style": {"color": "white", "textDecoration": "none", "fontSize": "1.1em"}}, ["Sign Up"])])]);
}
function LandingPage() {
  if (jacIsLoggedIn()) {
    return __jacJsx(Navigate, {"to": "/chat"}, []);
  }
  return __jacJsx("div", {"style": {"minHeight": "100vh", "background": "linear-gradient(rgba(15,23,42,0.4), rgba(24, 34, 54, 0.6)), url('https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed", "display": "flex", "flexDirection": "column", "alignItems": "center", "justifyContent": "center", "color": "#f8fafc", "textAlign": "center", "padding": "20px 15px", "fontFamily": "'Inter', system-ui, sans-serif"}}, [__jacJsx("div", {"style": {"marginBottom": "15px"}}, [__jacJsx("div", {"style": {"fontSize": "3em", "margin": "0 0 6px 0", "fontWeight": "900", "background": "linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%)", "backgroundClip": "text", "WebkitBackgroundClip": "text", "color": "transparent", "letterSpacing": "-0.5px"}}, ["🦟 MalariaPredict AI"]), __jacJsx("div", {"style": {"color": "#cbd5e1", "fontSize": "0.9em"}}, ["Advanced AI-Powered Malaria Detection System"])]), __jacJsx("h1", {"style": {"fontSize": "1.8em", "margin": "0 0 15px 0", "fontWeight": "700", "maxWidth": "700px", "lineHeight": "1.2"}}, ["Early Detection \u2022 Faster Action \u2022 ", __jacJsx("span", {"style": {"color": "#60a5fa"}}, ["Lives Saved"])]), __jacJsx("p", {"style": {"fontSize": "1em", "maxWidth": "650px", "margin": "0 0 25px 0", "opacity": 0.95, "lineHeight": "1.5", "color": "#c7d8eeff"}}, ["Bilingual AI companion for instant malaria symptom assessment, risk analysis, hospital finder, and prevention tips."]), __jacJsx("div", {"style": {"margin": "0 0 30px 0", "padding": "15px 25px", "background": "rgba(30, 41, 59, 0.7)", "borderRadius": "12px", "border": "1px solid rgba(100, 116, 139, 0.3)", "maxWidth": "600px"}}, [__jacJsx("p", {"style": {"fontSize": "1em", "margin": "0 0 10px 0", "color": "#60a5fa", "fontWeight": "600"}}, ["Ready to get started?"]), __jacJsx("p", {"style": {"margin": 0, "opacity": 0.9, "fontSize": "0.9em"}}, ["Log in or sign up to begin your personalized malaria health journey."])]), __jacJsx("div", {"style": {"display": "grid", "gridTemplateColumns": "repeat(auto-fit, minmax(180px, 1fr))", "gap": "15px", "maxWidth": "900px", "margin": "0 0 30px 0", "padding": "20px", "background": "rgba(30, 41, 59, 0.6)", "borderRadius": "16px"}}, [__jacJsx("div", {"style": {"padding": "10px"}}, [__jacJsx("div", {"style": {"fontSize": "1.8em", "marginBottom": "8px"}}, ["🤖"]), __jacJsx("h3", {"style": {"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}, ["AI Symptom Triage"]), __jacJsx("p", {"style": {"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}, ["Bilingual assessment in English & Kiswahili"])]), __jacJsx("div", {"style": {"padding": "10px"}}, [__jacJsx("div", {"style": {"fontSize": "1.8em", "marginBottom": "8px"}}, ["📊"]), __jacJsx("h3", {"style": {"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}, ["Risk Assessment"]), __jacJsx("p", {"style": {"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}, ["Personalized risk scoring"])]), __jacJsx("div", {"style": {"padding": "10px"}}, [__jacJsx("div", {"style": {"fontSize": "1.8em", "marginBottom": "8px"}}, ["🏥"]), __jacJsx("h3", {"style": {"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}, ["Hospital Finder"]), __jacJsx("p", {"style": {"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}, ["Nearest malaria treatment centers"])]), __jacJsx("div", {"style": {"padding": "10px"}}, [__jacJsx("div", {"style": {"fontSize": "1.8em", "marginBottom": "8px"}}, ["🛡️"]), __jacJsx("h3", {"style": {"margin": "0 0 6px 0", "fontSize": "1em", "color": "#60a5fa"}}, ["Prevention Tips"]), __jacJsx("p", {"style": {"margin": 0, "opacity": 0.9, "fontSize": "0.85em"}}, ["AI-generated strategies"])])]), __jacJsx("div", {"style": {"display": "flex", "gap": "30px", "marginBottom": "30px", "flexWrap": "wrap", "justifyContent": "center"}}, [__jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}, ["95%"]), __jacJsx("div", {"style": {"fontSize": "0.8em", "opacity": 0.8}}, ["Detection Accuracy"])]), __jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}, ["24/7"]), __jacJsx("div", {"style": {"fontSize": "0.8em", "opacity": 0.8}}, ["Availability"])]), __jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}, ["2 min"]), __jacJsx("div", {"style": {"fontSize": "0.8em", "opacity": 0.8}}, ["Average Assessment"])]), __jacJsx("div", {"style": {"textAlign": "center"}}, [__jacJsx("div", {"style": {"fontSize": "1.5em", "fontWeight": "800", "color": "#60a5fa"}}, ["10k+"]), __jacJsx("div", {"style": {"fontSize": "0.8em", "opacity": 0.8}}, ["Users Helped"])])]), __jacJsx("div", {"style": {"paddingTop": "20px", "maxWidth": "600px"}}, [__jacJsx("p", {"style": {"fontSize": "1em", "fontWeight": "600", "margin": "0 0 10px 0", "fontStyle": "italic", "color": "#cbd5e1"}}, ["Know sooner. Act faster. End malaria together."]), __jacJsx("p", {"style": {"fontSize": "0.8em", "opacity": 0.7, "margin": 0}}, ["© 2025 MalariaPredict AI"])])]);
}
function LoginPage() {
  if (jacIsLoggedIn()) {
    return __jacJsx(Navigate, {"to": "/chat"}, []);
  }
  let [email, setEmail] = useState("");
  let [password, setPassword] = useState("");
  let [error, setError] = useState("");
  let navigate = useNavigate();
  async function handleLogin(e) {
    e.preventDefault();
    setError("");
    let success = await jacLogin(email, password);
    if (success) {
      navigate("/chat");
    } else {
      setError("Invalid email or password");
    }
  }
  return __jacJsx("div", {"style": {"minHeight": "100vh", "background": "#0f172a", "display": "flex", "alignItems": "center", "justifyContent": "center", "padding": "20px"}}, [__jacJsx("div", {"style": {"background": "#1e293b", "padding": "40px", "borderRadius": "20px", "width": "100%", "maxWidth": "400px", "boxShadow": "0 10px 30px rgba(0,0,0,0.3)"}}, [__jacJsx("h2", {"style": {"textAlign": "center", "marginBottom": "30px", "color": "#1a5fb4"}}, ["Login"]), __jacJsx("form", {"onSubmit": handleLogin}, [__jacJsx("input", {"type": "email", "value": email, "onChange": e => {
    setEmail(e.target.value);
  }, "placeholder": "Email", "required": true, "style": {"width": "100%", "padding": "14px", "marginBottom": "16px", "borderRadius": "12px", "border": "none", "background": "#334155", "color": "white", "fontSize": "16px"}}, []), __jacJsx("input", {"type": "password", "value": password, "onChange": e => {
    setPassword(e.target.value);
  }, "placeholder": "Password", "required": true, "style": {"width": "100%", "padding": "14px", "marginBottom": "20px", "borderRadius": "12px", "border": "none", "background": "#334155", "color": "white", "fontSize": "16px"}}, []), error && __jacJsx("p", {"style": {"color": "#ef4444", "textAlign": "center", "marginBottom": "16px"}}, [error]), __jacJsx("button", {"type": "submit", "style": {"width": "100%", "padding": "16px", "background": "#1a5fb4", "color": "white", "border": "none", "borderRadius": "12px", "fontSize": "1.1em", "fontWeight": "600", "cursor": "pointer"}}, ["Login"])]), __jacJsx("p", {"style": {"textAlign": "center", "marginTop": "24px", "color": "#94a3b8"}}, ["Don't have an account? ", __jacJsx(Link, {"to": "/signup", "style": {"color": "#1a5fb4"}}, ["Sign Up"])])])]);
}
function SignupPage() {
  if (jacIsLoggedIn()) {
    return __jacJsx(Navigate, {"to": "/chat"}, []);
  }
  let [email, setEmail] = useState("");
  let [password, setPassword] = useState("");
  let [error, setError] = useState("");
  let navigate = useNavigate();
  async function handleSignup(e) {
    e.preventDefault();
    setError("");
    let result = await jacSignup(email, password);
    if (result["success"]) {
      navigate("/chat");
    } else {
      setError(result["error"] || "Signup failed");
    }
  }
  return __jacJsx("div", {"style": {"minHeight": "100vh", "background": "#0f172a", "display": "flex", "alignItems": "center", "justifyContent": "center", "padding": "20px"}}, [__jacJsx("div", {"style": {"background": "#1e293b", "padding": "40px", "borderRadius": "20px", "width": "100%", "maxWidth": "400px", "boxShadow": "0 10px 30px rgba(0,0,0,0.3)"}}, [__jacJsx("h2", {"style": {"textAlign": "center", "marginBottom": "30px", "color": "#1a5fb4"}}, ["Sign Up"]), __jacJsx("form", {"onSubmit": handleSignup}, [__jacJsx("input", {"type": "email", "value": email, "onChange": e => {
    setEmail(e.target.value);
  }, "placeholder": "Email", "required": true, "style": {"width": "100%", "padding": "14px", "marginBottom": "16px", "borderRadius": "12px", "border": "none", "background": "#334155", "color": "white", "fontSize": "16px"}}, []), __jacJsx("input", {"type": "password", "value": password, "onChange": e => {
    setPassword(e.target.value);
  }, "placeholder": "Password", "required": true, "style": {"width": "100%", "padding": "14px", "marginBottom": "20px", "borderRadius": "12px", "border": "none", "background": "#334155", "color": "white", "fontSize": "16px"}}, []), error && __jacJsx("p", {"style": {"color": "#ef4444", "textAlign": "center", "marginBottom": "16px"}}, [error]), __jacJsx("button", {"type": "submit", "style": {"width": "100%", "padding": "16px", "background": "#1a5fb4", "color": "white", "border": "none", "borderRadius": "12px", "fontSize": "1.1em", "fontWeight": "600", "cursor": "pointer"}}, ["Sign Up"])]), __jacJsx("p", {"style": {"textAlign": "center", "marginTop": "24px", "color": "#94a3b8"}}, ["Already have an account? ", __jacJsx(Link, {"to": "/login", "style": {"color": "#1a5fb4"}}, ["Login"])])])]);
}
function ChatPage() {
  if (!jacIsLoggedIn()) {
    return __jacJsx(Navigate, {"to": "/"}, []);
  }
  let [messages, setMessages] = useState([]);
  let [input, setInput] = useState("");
  let [loading, setLoading] = useState(false);
  let chatScrollRef = useRef(null);
  let [sessionId, _] = useState(() => {
    return "sess_" + crypto.randomUUID();
  });
  [messages, setMessages] = useState([{"sender": "bot", "text": "\ud83e\udd9f Welcome back to MalariaPredict AI!   Your trusted companion for:   \u2713 Symptom assessment    \u2713 Risk prediction  \u2713 Hospital location  \u2713 Prevention guidance.  How can I serve you today?"}]);
  useEffect(() => {
    sendMessage("");
  }, []);
  useEffect(() => {
    if (chatScrollRef.current) {
      chatScrollRef.current.scrollTop = chatScrollRef.current.scrollHeight;
    }
  }, [messages, loading]);
  async function sendMessage(text) {
    let currentInput = input.trim();
    if (!currentInput) {
      return;
    }
    let messageText = currentInput;
    setInput("");
    setLoading(true);
    let currentMessages = messages;
    setMessages(currentMessages.concat([{"sender": "user", "text": messageText}]));
    let result = await __jacSpawn("root_walker", "", {"message": messageText, "session_id": sessionId});
    let bot_reply = "No response from bot";
    if (result && result.reports && result.reports.length > 0) {
      let response = result.reports[0]["response"];
      bot_reply = response.join("\\n");
      console.log("result:" + result);
      console.log("result_report:" + result.reports);
      console.log(result.reports[0]["response"]);
    }
    setMessages(currentMessages.concat([{"sender": "user", "text": messageText}, {"sender": "bot", "text": bot_reply}]));
    setLoading(false);
  }
  function handleKeyPress(event) {
    if (event.key === "Enter") {
      sendMessage();
    }
  }
  return __jacJsx("div", {"style": {"height": "100vh", "display": "flex", "flexDirection": "column", "background": "#0f172a", "color": "#f0f0f0"}}, [__jacJsx("div", {"ref": chatScrollRef, "style": {"flex": 1, "overflowY": "auto", "padding": "15px", "display": "flex", "flexDirection": "column"}}, [messages.map(MessageBubble), loading && __jacJsx("div", {"style": {"color": "#aaa", "fontStyle": "italic"}}, ["Thinking..."])]), __jacJsx("div", {"style": {"padding": "20px", "background": "#111", "display": "flex", "gap": "10px"}}, [__jacJsx("input", {"value": input, "onChange": e => {
    setInput(e.target.value);
  }, "onKeyPress": e => {
    if (e.key === "Enter") {
      sendMessage(input);
    }
  }, "placeholder": "Type here...", "style": {"flex": 1, "padding": "16px", "borderRadius": "30px", "border": "none", "background": "#1e293b", "color": "white", "fontSize": "16px"}}, []), __jacJsx("button", {"onClick": () => {
    sendMessage(input);
  }, "style": {"background": "#1a5fb4", "color": "white", "border": "none", "borderRadius": "30px", "padding": "0 30px"}}, ["Send"])]), __jacJsx("div", {"style": {"marginTop": "32px", "paddingBottom": "24px", "textAlign": "center", "color": "rgba(240, 240, 240, 0.6)", "fontSize": "0.95rem", "fontWeight": "500"}}, ["⚡ Built with Jaseci Stack"])]);
}
function app() {
  return __jacJsx(Router, {}, [__jacJsx(Navigation, {}, []), __jacJsx(Routes, {}, [__jacJsx(Route, {"path": "/", "element": __jacJsx(LandingPage, {}, [])}, []), __jacJsx(Route, {"path": "/login", "element": __jacJsx(LoginPage, {}, [])}, []), __jacJsx(Route, {"path": "/signup", "element": __jacJsx(SignupPage, {}, [])}, []), __jacJsx(Route, {"path": "/chat", "element": __jacJsx(ChatPage, {}, [])}, []), __jacJsx(Route, {"path": "*", "element": __jacJsx(Navigate, {"to": "/"}, [])}, [])])]);
}
export { ChatPage, LandingPage, LoginPage, MessageBubble, Navigation, SignupPage, app };
