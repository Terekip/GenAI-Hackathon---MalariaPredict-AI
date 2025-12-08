import streamlit as st
import requests
import uuid;

# -----------------------------
# Page Configuration
# -----------------------------
st.set_page_config(
    page_title="MalariaPredict AI",
    page_icon="🦟",
    layout="centered",
    
)

st.title("Mosquito MalariaPredict AI")
st.markdown("### *Saving lives in Kenya & Tanzania — one chat at a time*")

# -----------------------------
# Initialize session state
# -----------------------------
if "messages" not in st.session_state:
    st.session_state.messages = []

if "session_id" not in st.session_state:
    st.session_state.session_id = str(uuid.uuid4())  # Will be set by backend

# -----------------------------
# Display chat history
# -----------------------------
for msg in st.session_state.messages:
    with st.chat_message(msg["role"]):
        st.markdown(msg["content"])

# -----------------------------
# User input
# -----------------------------
if prompt := st.chat_input("Type your message here..."):
    # Add user message to chat
    st.session_state.messages.append({"role": "user", "content": prompt})
    with st.chat_message("user"):
        st.markdown(prompt)

    # Send message directly to backend with flat JSON
    with st.chat_message("assistant"):
        with st.spinner("Thinking..."):
            try:
                payload = {
                    "message": prompt,
                    "session_id": st.session_state.session_id
                }
                response = requests.post(
                    "http://localhost:8000/walker/root",
                    json=payload,
                    timeout=30
                )

                if response.status_code == 200:
                    data = response.json()
                    print("RAW RESPONSE:", data)  # confirm structure

                # Get the last report that contains 'response'
                    bot_report = next((r for r in data.get("reports", []) if "response" in r), None)

                    if bot_report:
                        bot_reply = "\n".join(bot_report["response"])  # join list into string
                    else:
                        bot_reply = "No reply from bot"

                    st.text(bot_reply)  
                    st.session_state.messages.append({"role": "assistant", "content": bot_reply})


                else:
                    st.error(f"Backend error: {response.status_code} — {response.text}")

            except requests.exceptions.RequestException:
                st.error("Bot is not running. Run: `jac serve malaria_bot.jac`")

# -----------------------------
# Footer
# -----------------------------
st.markdown("---")
st.caption("Made with ❤️ for the Malaria Hackathon | Powered by Jac + Streamlit")
