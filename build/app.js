function _regenerator() { /*! regenerator-runtime -- Copyright (c) 2014-present, Facebook, Inc. -- license (MIT): https://github.com/babel/babel/blob/main/packages/babel-helpers/LICENSE */ var e, t, r = "function" == typeof Symbol ? Symbol : {}, n = r.iterator || "@@iterator", o = r.toStringTag || "@@toStringTag"; function i(r, n, o, i) { var c = n && n.prototype instanceof Generator ? n : Generator, u = Object.create(c.prototype); return _regeneratorDefine2(u, "_invoke", function (r, n, o) { var i, c, u, f = 0, p = o || [], y = !1, G = { p: 0, n: 0, v: e, a: d, f: d.bind(e, 4), d: function d(t, r) { return i = t, c = 0, u = e, G.n = r, a; } }; function d(r, n) { for (c = r, u = n, t = 0; !y && f && !o && t < p.length; t++) { var o, i = p[t], d = G.p, l = i[2]; r > 3 ? (o = l === n) && (u = i[(c = i[4]) ? 5 : (c = 3, 3)], i[4] = i[5] = e) : i[0] <= d && ((o = r < 2 && d < i[1]) ? (c = 0, G.v = n, G.n = i[1]) : d < l && (o = r < 3 || i[0] > n || n > l) && (i[4] = r, i[5] = n, G.n = l, c = 0)); } if (o || r > 1) return a; throw y = !0, n; } return function (o, p, l) { if (f > 1) throw TypeError("Generator is already running"); for (y && 1 === p && d(p, l), c = p, u = l; (t = c < 2 ? e : u) || !y;) { i || (c ? c < 3 ? (c > 1 && (G.n = -1), d(c, u)) : G.n = u : G.v = u); try { if (f = 2, i) { if (c || (o = "next"), t = i[o]) { if (!(t = t.call(i, u))) throw TypeError("iterator result is not an object"); if (!t.done) return t; u = t.value, c < 2 && (c = 0); } else 1 === c && (t = i["return"]) && t.call(i), c < 2 && (u = TypeError("The iterator does not provide a '" + o + "' method"), c = 1); i = e; } else if ((t = (y = G.n < 0) ? u : r.call(n, G)) !== a) break; } catch (t) { i = e, c = 1, u = t; } finally { f = 1; } } return { value: t, done: y }; }; }(r, o, i), !0), u; } var a = {}; function Generator() {} function GeneratorFunction() {} function GeneratorFunctionPrototype() {} t = Object.getPrototypeOf; var c = [][n] ? t(t([][n]())) : (_regeneratorDefine2(t = {}, n, function () { return this; }), t), u = GeneratorFunctionPrototype.prototype = Generator.prototype = Object.create(c); function f(e) { return Object.setPrototypeOf ? Object.setPrototypeOf(e, GeneratorFunctionPrototype) : (e.__proto__ = GeneratorFunctionPrototype, _regeneratorDefine2(e, o, "GeneratorFunction")), e.prototype = Object.create(u), e; } return GeneratorFunction.prototype = GeneratorFunctionPrototype, _regeneratorDefine2(u, "constructor", GeneratorFunctionPrototype), _regeneratorDefine2(GeneratorFunctionPrototype, "constructor", GeneratorFunction), GeneratorFunction.displayName = "GeneratorFunction", _regeneratorDefine2(GeneratorFunctionPrototype, o, "GeneratorFunction"), _regeneratorDefine2(u), _regeneratorDefine2(u, o, "Generator"), _regeneratorDefine2(u, n, function () { return this; }), _regeneratorDefine2(u, "toString", function () { return "[object Generator]"; }), (_regenerator = function _regenerator() { return { w: i, m: f }; })(); }
function _regeneratorDefine2(e, r, n, t) { var i = Object.defineProperty; try { i({}, "", {}); } catch (e) { i = 0; } _regeneratorDefine2 = function _regeneratorDefine(e, r, n, t) { function o(r, n) { _regeneratorDefine2(e, r, function (e) { return this._invoke(r, n, e); }); } r ? i ? i(e, r, { value: n, enumerable: !t, configurable: !t, writable: !t }) : e[r] = n : (o("next", 0), o("throw", 1), o("return", 2)); }, _regeneratorDefine2(e, r, n, t); }
function asyncGeneratorStep(n, t, e, r, o, a, c) { try { var i = n[a](c), u = i.value; } catch (n) { return void e(n); } i.done ? t(u) : Promise.resolve(u).then(r, o); }
function _asyncToGenerator(n) { return function () { var t = this, e = arguments; return new Promise(function (r, o) { var a = n.apply(t, e); function _next(n) { asyncGeneratorStep(a, r, o, _next, _throw, "next", n); } function _throw(n) { asyncGeneratorStep(a, r, o, _next, _throw, "throw", n); } _next(void 0); }); }; }
function _slicedToArray(r, e) { return _arrayWithHoles(r) || _iterableToArrayLimit(r, e) || _unsupportedIterableToArray(r, e) || _nonIterableRest(); }
function _nonIterableRest() { throw new TypeError("Invalid attempt to destructure non-iterable instance.\nIn order to be iterable, non-array objects must have a [Symbol.iterator]() method."); }
function _unsupportedIterableToArray(r, a) { if (r) { if ("string" == typeof r) return _arrayLikeToArray(r, a); var t = {}.toString.call(r).slice(8, -1); return "Object" === t && r.constructor && (t = r.constructor.name), "Map" === t || "Set" === t ? Array.from(r) : "Arguments" === t || /^(?:Ui|I)nt(?:8|16|32)(?:Clamped)?Array$/.test(t) ? _arrayLikeToArray(r, a) : void 0; } }
function _arrayLikeToArray(r, a) { (null == a || a > r.length) && (a = r.length); for (var e = 0, n = Array(a); e < a; e++) n[e] = r[e]; return n; }
function _iterableToArrayLimit(r, l) { var t = null == r ? null : "undefined" != typeof Symbol && r[Symbol.iterator] || r["@@iterator"]; if (null != t) { var e, n, i, u, a = [], f = !0, o = !1; try { if (i = (t = t.call(r)).next, 0 === l) { if (Object(t) !== t) return; f = !1; } else for (; !(f = (e = i.call(t)).done) && (a.push(e.value), a.length !== l); f = !0); } catch (r) { o = !0, n = r; } finally { try { if (!f && null != t["return"] && (u = t["return"](), Object(u) !== u)) return; } finally { if (o) throw n; } } return a; } }
function _arrayWithHoles(r) { if (Array.isArray(r)) return r; }
function _typeof(o) { "@babel/helpers - typeof"; return _typeof = "function" == typeof Symbol && "symbol" == typeof Symbol.iterator ? function (o) { return typeof o; } : function (o) { return o && "function" == typeof Symbol && o.constructor === Symbol && o !== Symbol.prototype ? "symbol" : typeof o; }, _typeof(o); }
import { __jacJsx, __jacSpawn } from "@jac-client/utils";
import { useState, useEffect, useRef } from "react";
import { Router, Routes, Route, Link, Navigate, useNavigate, jacSignup, jacLogin, jacLogout, jacIsLoggedIn } from "@jac-client/utils";
function MessageBubble(msg, index) {
  if (!msg || !msg.text || msg.text === "undefined") {
    return __jacJsx("div", {
      "key": index,
      "style": {
        "display": "none"
      }
    }, []);
  }
  var displayText = "";
  if (typeof msg.text === "string") {
    displayText = msg.text;
  } else if (msg.text && _typeof(msg.text) === "object" && "response" in msg.text) {
    var responseArray = msg.text["response"];
    if (typeof responseArray === "array" && len(responseArray) > 0) {
      displayText = responseArray.join("\\n");
    } else {
      displayText = "Invalid response";
    }
  } else {
    displayText = "" + msg.text;
    console.log("TYPE:", _typeof(msg.text["response"]));
    console.log("VALUE:", msg.text["response"]);
  }
  if (msg.sender === "bot") {
    return __jacJsx("div", {
      "key": index,
      "style": {
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
      }
    }, [displayText]);
  } else {
    return __jacJsx("div", {
      "key": index,
      "style": {
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
      }
    }, [displayText]);
  }
}
function Navigation() {
  var isLoggedIn = jacIsLoggedIn();
  var navigate = useNavigate();
  function handleLogout() {
    jacLogout();
    navigate("/");
  }
  return __jacJsx("nav", {
    "style": {
      "padding": "16px 32px",
      "background": "#1a5fb4",
      "color": "white",
      "display": "flex",
      "justifyContent": "space-between",
      "alignItems": "center",
      "fontFamily": "system-ui, sans-serif",
      "boxShadow": "0 2px 10px rgba(0,0,0,0.1)"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.6em",
      "fontWeight": "700"
    }
  }, ["🦟 MalariaPredict AI"]), isLoggedIn && __jacJsx("button", {
    "onClick": handleLogout,
    "style": {
      "background": "transparent",
      "color": "white",
      "border": "2px solid white",
      "padding": "8px 20px",
      "borderRadius": "30px",
      "cursor": "pointer",
      "fontWeight": "600"
    }
  }, ["Logout"]), isLoggedIn === false && __jacJsx("div", {
    "style": {
      "display": "flex",
      "gap": "20px"
    }
  }, [__jacJsx(Link, {
    "to": "/login",
    "style": {
      "color": "white",
      "textDecoration": "none",
      "fontSize": "1.1em"
    }
  }, ["Login"]), __jacJsx(Link, {
    "to": "/signup",
    "style": {
      "color": "white",
      "textDecoration": "none",
      "fontSize": "1.1em"
    }
  }, ["Sign Up"])])]);
}
function LandingPage() {
  if (jacIsLoggedIn()) {
    return __jacJsx(Navigate, {
      "to": "/chat"
    }, []);
  }
  return __jacJsx("div", {
    "style": {
      "minHeight": "100vh",
      "background": "linear-gradient(rgba(15,23,42,0.4), rgba(24, 34, 54, 0.6)), url('https://images.unsplash.com/photo-1516026672322-bc52d61a55d5?ixlib=rb-4.0.3&auto=format&fit=crop&w=1920&q=80') center/cover no-repeat fixed",
      "display": "flex",
      "flexDirection": "column",
      "alignItems": "center",
      "justifyContent": "center",
      "color": "#f8fafc",
      "textAlign": "center",
      "padding": "20px 15px",
      "fontFamily": "'Inter', system-ui, sans-serif"
    }
  }, [__jacJsx("div", {
    "style": {
      "marginBottom": "15px"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "3em",
      "margin": "0 0 6px 0",
      "fontWeight": "900",
      "background": "linear-gradient(135deg, #60a5fa 0%, #3b82f6 100%)",
      "backgroundClip": "text",
      "WebkitBackgroundClip": "text",
      "color": "transparent",
      "letterSpacing": "-0.5px"
    }
  }, ["🦟 MalariaPredict AI"]), __jacJsx("div", {
    "style": {
      "color": "#cbd5e1",
      "fontSize": "0.9em"
    }
  }, ["Advanced AI-Powered Malaria Detection System"])]), __jacJsx("h1", {
    "style": {
      "fontSize": "1.8em",
      "margin": "0 0 15px 0",
      "fontWeight": "700",
      "maxWidth": "700px",
      "lineHeight": "1.2"
    }
  }, ["Early Detection \u2022 Faster Action \u2022 ", __jacJsx("span", {
    "style": {
      "color": "#60a5fa"
    }
  }, ["Lives Saved"])]), __jacJsx("p", {
    "style": {
      "fontSize": "1em",
      "maxWidth": "650px",
      "margin": "0 0 25px 0",
      "opacity": 0.95,
      "lineHeight": "1.5",
      "color": "#c7d8eeff"
    }
  }, ["Bilingual AI companion for instant malaria symptom assessment, risk analysis, hospital finder, and prevention tips."]), __jacJsx("div", {
    "style": {
      "margin": "0 0 30px 0",
      "padding": "15px 25px",
      "background": "rgba(30, 41, 59, 0.7)",
      "borderRadius": "12px",
      "border": "1px solid rgba(100, 116, 139, 0.3)",
      "maxWidth": "600px"
    }
  }, [__jacJsx("p", {
    "style": {
      "fontSize": "1em",
      "margin": "0 0 10px 0",
      "color": "#60a5fa",
      "fontWeight": "600"
    }
  }, ["Ready to get started?"]), __jacJsx("p", {
    "style": {
      "margin": 0,
      "opacity": 0.9,
      "fontSize": "0.9em"
    }
  }, ["Log in or sign up to begin your personalized malaria health journey."])]), __jacJsx("div", {
    "style": {
      "display": "grid",
      "gridTemplateColumns": "repeat(auto-fit, minmax(180px, 1fr))",
      "gap": "15px",
      "maxWidth": "900px",
      "margin": "0 0 30px 0",
      "padding": "20px",
      "background": "rgba(30, 41, 59, 0.6)",
      "borderRadius": "16px"
    }
  }, [__jacJsx("div", {
    "style": {
      "padding": "10px"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.8em",
      "marginBottom": "8px"
    }
  }, ["🤖"]), __jacJsx("h3", {
    "style": {
      "margin": "0 0 6px 0",
      "fontSize": "1em",
      "color": "#60a5fa"
    }
  }, ["AI Symptom Triage"]), __jacJsx("p", {
    "style": {
      "margin": 0,
      "opacity": 0.9,
      "fontSize": "0.85em"
    }
  }, ["Bilingual assessment in English & Kiswahili"])]), __jacJsx("div", {
    "style": {
      "padding": "10px"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.8em",
      "marginBottom": "8px"
    }
  }, ["📊"]), __jacJsx("h3", {
    "style": {
      "margin": "0 0 6px 0",
      "fontSize": "1em",
      "color": "#60a5fa"
    }
  }, ["Risk Assessment"]), __jacJsx("p", {
    "style": {
      "margin": 0,
      "opacity": 0.9,
      "fontSize": "0.85em"
    }
  }, ["Personalized risk scoring"])]), __jacJsx("div", {
    "style": {
      "padding": "10px"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.8em",
      "marginBottom": "8px"
    }
  }, ["🏥"]), __jacJsx("h3", {
    "style": {
      "margin": "0 0 6px 0",
      "fontSize": "1em",
      "color": "#60a5fa"
    }
  }, ["Hospital Finder"]), __jacJsx("p", {
    "style": {
      "margin": 0,
      "opacity": 0.9,
      "fontSize": "0.85em"
    }
  }, ["Nearest malaria treatment centers"])]), __jacJsx("div", {
    "style": {
      "padding": "10px"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.8em",
      "marginBottom": "8px"
    }
  }, ["🛡️"]), __jacJsx("h3", {
    "style": {
      "margin": "0 0 6px 0",
      "fontSize": "1em",
      "color": "#60a5fa"
    }
  }, ["Prevention Tips"]), __jacJsx("p", {
    "style": {
      "margin": 0,
      "opacity": 0.9,
      "fontSize": "0.85em"
    }
  }, ["AI-generated strategies"])])]), __jacJsx("div", {
    "style": {
      "display": "flex",
      "gap": "30px",
      "marginBottom": "30px",
      "flexWrap": "wrap",
      "justifyContent": "center"
    }
  }, [__jacJsx("div", {
    "style": {
      "textAlign": "center"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.5em",
      "fontWeight": "800",
      "color": "#60a5fa"
    }
  }, ["95%"]), __jacJsx("div", {
    "style": {
      "fontSize": "0.8em",
      "opacity": 0.8
    }
  }, ["Detection Accuracy"])]), __jacJsx("div", {
    "style": {
      "textAlign": "center"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.5em",
      "fontWeight": "800",
      "color": "#60a5fa"
    }
  }, ["24/7"]), __jacJsx("div", {
    "style": {
      "fontSize": "0.8em",
      "opacity": 0.8
    }
  }, ["Availability"])]), __jacJsx("div", {
    "style": {
      "textAlign": "center"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.5em",
      "fontWeight": "800",
      "color": "#60a5fa"
    }
  }, ["2 min"]), __jacJsx("div", {
    "style": {
      "fontSize": "0.8em",
      "opacity": 0.8
    }
  }, ["Average Assessment"])]), __jacJsx("div", {
    "style": {
      "textAlign": "center"
    }
  }, [__jacJsx("div", {
    "style": {
      "fontSize": "1.5em",
      "fontWeight": "800",
      "color": "#60a5fa"
    }
  }, ["10k+"]), __jacJsx("div", {
    "style": {
      "fontSize": "0.8em",
      "opacity": 0.8
    }
  }, ["Users Helped"])])]), __jacJsx("div", {
    "style": {
      "paddingTop": "20px",
      "maxWidth": "600px"
    }
  }, [__jacJsx("p", {
    "style": {
      "fontSize": "1em",
      "fontWeight": "600",
      "margin": "0 0 10px 0",
      "fontStyle": "italic",
      "color": "#cbd5e1"
    }
  }, ["Know sooner. Act faster. End malaria together."]), __jacJsx("p", {
    "style": {
      "fontSize": "0.8em",
      "opacity": 0.7,
      "margin": 0
    }
  }, ["© 2025 MalariaPredict AI"])])]);
}
function LoginPage() {
  if (jacIsLoggedIn()) {
    return __jacJsx(Navigate, {
      "to": "/chat"
    }, []);
  }
  var _useState = useState(""),
    _useState2 = _slicedToArray(_useState, 2),
    email = _useState2[0],
    setEmail = _useState2[1];
  var _useState3 = useState(""),
    _useState4 = _slicedToArray(_useState3, 2),
    password = _useState4[0],
    setPassword = _useState4[1];
  var _useState5 = useState(""),
    _useState6 = _slicedToArray(_useState5, 2),
    error = _useState6[0],
    setError = _useState6[1];
  var navigate = useNavigate();
  function handleLogin(_x) {
    return _handleLogin.apply(this, arguments);
  }
  function _handleLogin() {
    _handleLogin = _asyncToGenerator(/*#__PURE__*/_regenerator().m(function _callee(e) {
      var success;
      return _regenerator().w(function (_context) {
        while (1) switch (_context.n) {
          case 0:
            e.preventDefault();
            setError("");
            _context.n = 1;
            return jacLogin(email, password);
          case 1:
            success = _context.v;
            if (success) {
              navigate("/chat");
            } else {
              setError("Invalid email or password");
            }
          case 2:
            return _context.a(2);
        }
      }, _callee);
    }));
    return _handleLogin.apply(this, arguments);
  }
  return __jacJsx("div", {
    "style": {
      "minHeight": "100vh",
      "background": "#0f172a",
      "display": "flex",
      "alignItems": "center",
      "justifyContent": "center",
      "padding": "20px"
    }
  }, [__jacJsx("div", {
    "style": {
      "background": "#1e293b",
      "padding": "40px",
      "borderRadius": "20px",
      "width": "100%",
      "maxWidth": "400px",
      "boxShadow": "0 10px 30px rgba(0,0,0,0.3)"
    }
  }, [__jacJsx("h2", {
    "style": {
      "textAlign": "center",
      "marginBottom": "30px",
      "color": "#1a5fb4"
    }
  }, ["Login"]), __jacJsx("form", {
    "onSubmit": handleLogin
  }, [__jacJsx("input", {
    "type": "email",
    "value": email,
    "onChange": function onChange(e) {
      setEmail(e.target.value);
    },
    "placeholder": "Email",
    "required": true,
    "style": {
      "width": "100%",
      "padding": "14px",
      "marginBottom": "16px",
      "borderRadius": "12px",
      "border": "none",
      "background": "#334155",
      "color": "white",
      "fontSize": "16px"
    }
  }, []), __jacJsx("input", {
    "type": "password",
    "value": password,
    "onChange": function onChange(e) {
      setPassword(e.target.value);
    },
    "placeholder": "Password",
    "required": true,
    "style": {
      "width": "100%",
      "padding": "14px",
      "marginBottom": "20px",
      "borderRadius": "12px",
      "border": "none",
      "background": "#334155",
      "color": "white",
      "fontSize": "16px"
    }
  }, []), error && __jacJsx("p", {
    "style": {
      "color": "#ef4444",
      "textAlign": "center",
      "marginBottom": "16px"
    }
  }, [error]), __jacJsx("button", {
    "type": "submit",
    "style": {
      "width": "100%",
      "padding": "16px",
      "background": "#1a5fb4",
      "color": "white",
      "border": "none",
      "borderRadius": "12px",
      "fontSize": "1.1em",
      "fontWeight": "600",
      "cursor": "pointer"
    }
  }, ["Login"])]), __jacJsx("p", {
    "style": {
      "textAlign": "center",
      "marginTop": "24px",
      "color": "#94a3b8"
    }
  }, ["Don't have an account? ", __jacJsx(Link, {
    "to": "/signup",
    "style": {
      "color": "#1a5fb4"
    }
  }, ["Sign Up"])])])]);
}
function SignupPage() {
  if (jacIsLoggedIn()) {
    return __jacJsx(Navigate, {
      "to": "/chat"
    }, []);
  }
  var _useState7 = useState(""),
    _useState8 = _slicedToArray(_useState7, 2),
    email = _useState8[0],
    setEmail = _useState8[1];
  var _useState9 = useState(""),
    _useState0 = _slicedToArray(_useState9, 2),
    password = _useState0[0],
    setPassword = _useState0[1];
  var _useState1 = useState(""),
    _useState10 = _slicedToArray(_useState1, 2),
    error = _useState10[0],
    setError = _useState10[1];
  var navigate = useNavigate();
  function handleSignup(_x2) {
    return _handleSignup.apply(this, arguments);
  }
  function _handleSignup() {
    _handleSignup = _asyncToGenerator(/*#__PURE__*/_regenerator().m(function _callee2(e) {
      var result;
      return _regenerator().w(function (_context2) {
        while (1) switch (_context2.n) {
          case 0:
            e.preventDefault();
            setError("");
            _context2.n = 1;
            return jacSignup(email, password);
          case 1:
            result = _context2.v;
            if (result["success"]) {
              navigate("/chat");
            } else {
              setError(result["error"] || "Signup failed");
            }
          case 2:
            return _context2.a(2);
        }
      }, _callee2);
    }));
    return _handleSignup.apply(this, arguments);
  }
  return __jacJsx("div", {
    "style": {
      "minHeight": "100vh",
      "background": "#0f172a",
      "display": "flex",
      "alignItems": "center",
      "justifyContent": "center",
      "padding": "20px"
    }
  }, [__jacJsx("div", {
    "style": {
      "background": "#1e293b",
      "padding": "40px",
      "borderRadius": "20px",
      "width": "100%",
      "maxWidth": "400px",
      "boxShadow": "0 10px 30px rgba(0,0,0,0.3)"
    }
  }, [__jacJsx("h2", {
    "style": {
      "textAlign": "center",
      "marginBottom": "30px",
      "color": "#1a5fb4"
    }
  }, ["Sign Up"]), __jacJsx("form", {
    "onSubmit": handleSignup
  }, [__jacJsx("input", {
    "type": "email",
    "value": email,
    "onChange": function onChange(e) {
      setEmail(e.target.value);
    },
    "placeholder": "Email",
    "required": true,
    "style": {
      "width": "100%",
      "padding": "14px",
      "marginBottom": "16px",
      "borderRadius": "12px",
      "border": "none",
      "background": "#334155",
      "color": "white",
      "fontSize": "16px"
    }
  }, []), __jacJsx("input", {
    "type": "password",
    "value": password,
    "onChange": function onChange(e) {
      setPassword(e.target.value);
    },
    "placeholder": "Password",
    "required": true,
    "style": {
      "width": "100%",
      "padding": "14px",
      "marginBottom": "20px",
      "borderRadius": "12px",
      "border": "none",
      "background": "#334155",
      "color": "white",
      "fontSize": "16px"
    }
  }, []), error && __jacJsx("p", {
    "style": {
      "color": "#ef4444",
      "textAlign": "center",
      "marginBottom": "16px"
    }
  }, [error]), __jacJsx("button", {
    "type": "submit",
    "style": {
      "width": "100%",
      "padding": "16px",
      "background": "#1a5fb4",
      "color": "white",
      "border": "none",
      "borderRadius": "12px",
      "fontSize": "1.1em",
      "fontWeight": "600",
      "cursor": "pointer"
    }
  }, ["Sign Up"])]), __jacJsx("p", {
    "style": {
      "textAlign": "center",
      "marginTop": "24px",
      "color": "#94a3b8"
    }
  }, ["Already have an account? ", __jacJsx(Link, {
    "to": "/login",
    "style": {
      "color": "#1a5fb4"
    }
  }, ["Login"])])])]);
}
function ChatPage() {
  if (!jacIsLoggedIn()) {
    return __jacJsx(Navigate, {
      "to": "/"
    }, []);
  }
  var _useState11 = useState([]),
    _useState12 = _slicedToArray(_useState11, 2),
    messages = _useState12[0],
    setMessages = _useState12[1];
  var _useState13 = useState(""),
    _useState14 = _slicedToArray(_useState13, 2),
    input = _useState14[0],
    setInput = _useState14[1];
  var _useState15 = useState(false),
    _useState16 = _slicedToArray(_useState15, 2),
    loading = _useState16[0],
    setLoading = _useState16[1];
  var chatScrollRef = useRef(null);
  var _useState17 = useState(function () {
      return "sess_" + crypto.randomUUID();
    }),
    _useState18 = _slicedToArray(_useState17, 2),
    sessionId = _useState18[0],
    _ = _useState18[1];
  var _useState19 = useState([{
    "sender": "bot",
    "text": "\uD83E\uDD9F Welcome back to MalariaPredict AI!   Your trusted companion for:   \u2713 Symptom assessment    \u2713 Risk prediction  \u2713 Hospital location  \u2713 Prevention guidance.  How can I serve you today?"
  }]);
  var _useState20 = _slicedToArray(_useState19, 2);
  messages = _useState20[0];
  setMessages = _useState20[1];
  useEffect(function () {
    sendMessage("");
  }, []);
  useEffect(function () {
    if (chatScrollRef.current) {
      chatScrollRef.current.scrollTop = chatScrollRef.current.scrollHeight;
    }
  }, [messages, loading]);
  function sendMessage(_x3) {
    return _sendMessage.apply(this, arguments);
  }
  function _sendMessage() {
    _sendMessage = _asyncToGenerator(/*#__PURE__*/_regenerator().m(function _callee3(text) {
      var currentInput, messageText, currentMessages, result, bot_reply, response;
      return _regenerator().w(function (_context3) {
        while (1) switch (_context3.n) {
          case 0:
            currentInput = input.trim();
            if (currentInput) {
              _context3.n = 1;
              break;
            }
            return _context3.a(2);
          case 1:
            messageText = currentInput;
            setInput("");
            setLoading(true);
            currentMessages = messages;
            setMessages(currentMessages.concat([{
              "sender": "user",
              "text": messageText
            }]));
            _context3.n = 2;
            return __jacSpawn("root_walker", "", {
              "message": messageText,
              "session_id": sessionId
            });
          case 2:
            result = _context3.v;
            bot_reply = "No response from bot";
            if (result && result.reports && result.reports.length > 0) {
              response = result.reports[0]["response"];
              bot_reply = response.join("\\n");
              console.log("result:" + result);
              console.log("result_report:" + result.reports);
              console.log(result.reports[0]["response"]);
            }
            setMessages(currentMessages.concat([{
              "sender": "user",
              "text": messageText
            }, {
              "sender": "bot",
              "text": bot_reply
            }]));
            setLoading(false);
          case 3:
            return _context3.a(2);
        }
      }, _callee3);
    }));
    return _sendMessage.apply(this, arguments);
  }
  function handleKeyPress(event) {
    if (event.key === "Enter") {
      sendMessage();
    }
  }
  return __jacJsx("div", {
    "style": {
      "height": "100vh",
      "display": "flex",
      "flexDirection": "column",
      "background": "#0f172a",
      "color": "#f0f0f0"
    }
  }, [__jacJsx("div", {
    "ref": chatScrollRef,
    "style": {
      "flex": 1,
      "overflowY": "auto",
      "padding": "15px",
      "display": "flex",
      "flexDirection": "column"
    }
  }, [messages.map(MessageBubble), loading && __jacJsx("div", {
    "style": {
      "color": "#aaa",
      "fontStyle": "italic"
    }
  }, ["Thinking..."])]), __jacJsx("div", {
    "style": {
      "padding": "20px",
      "background": "#111",
      "display": "flex",
      "gap": "10px"
    }
  }, [__jacJsx("input", {
    "value": input,
    "onChange": function onChange(e) {
      setInput(e.target.value);
    },
    "onKeyPress": function onKeyPress(e) {
      if (e.key === "Enter") {
        sendMessage(input);
      }
    },
    "placeholder": "Type here...",
    "style": {
      "flex": 1,
      "padding": "16px",
      "borderRadius": "30px",
      "border": "none",
      "background": "#1e293b",
      "color": "white",
      "fontSize": "16px"
    }
  }, []), __jacJsx("button", {
    "onClick": function onClick() {
      sendMessage(input);
    },
    "style": {
      "background": "#1a5fb4",
      "color": "white",
      "border": "none",
      "borderRadius": "30px",
      "padding": "0 30px"
    }
  }, ["Send"])]), __jacJsx("div", {
    "style": {
      "marginTop": "32px",
      "paddingBottom": "24px",
      "textAlign": "center",
      "color": "rgba(240, 240, 240, 0.6)",
      "fontSize": "0.95rem",
      "fontWeight": "500"
    }
  }, ["⚡ Built with Jaseci Stack"])]);
}
function app() {
  return __jacJsx(Router, {}, [__jacJsx(Navigation, {}, []), __jacJsx(Routes, {}, [__jacJsx(Route, {
    "path": "/",
    "element": __jacJsx(LandingPage, {}, [])
  }, []), __jacJsx(Route, {
    "path": "/login",
    "element": __jacJsx(LoginPage, {}, [])
  }, []), __jacJsx(Route, {
    "path": "/signup",
    "element": __jacJsx(SignupPage, {}, [])
  }, []), __jacJsx(Route, {
    "path": "/chat",
    "element": __jacJsx(ChatPage, {}, [])
  }, []), __jacJsx(Route, {
    "path": "*",
    "element": __jacJsx(Navigate, {
      "to": "/"
    }, [])
  }, [])])]);
}
export { ChatPage, LandingPage, LoginPage, MessageBubble, Navigation, SignupPage, app };