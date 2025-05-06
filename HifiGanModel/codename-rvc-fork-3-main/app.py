import gradio as gr
import sys
import os
import logging

# Constants
DEFAULT_PORT = 7897
MAX_PORT_ATTEMPTS = 10

# Set up logging
logging.getLogger("uvicorn").setLevel(logging.WARNING)
logging.getLogger("httpx").setLevel(logging.WARNING)

# Add current directory to sys.path
now_dir = os.getcwd()
sys.path.append(now_dir)

# Import Tabs
from tabs.inference.inference import inference_tab

# Initialize i18n
from assets.i18n.i18n import I18nAuto
i18n = I18nAuto()

# Load theme
import assets.themes.loadThemes as loadThemes
CodenameViolet = loadThemes.load_theme() or "ParityError/Interstellar"

# Define Gradio interface
with gr.Blocks(
    theme=CodenameViolet, title="RVC Inference", css="footer{display:none !important}"
) as Applio:
    gr.Markdown("# RVC Inference")
    gr.Markdown(
        i18n(
            "ㅤㅤVoice Conversion Interfaceㅤㅤ"
        )
    )
    with gr.Tab(i18n("Inference")):
        inference_tab()

def launch_gradio(port):
    Applio.launch(
        favicon_path="assets/ICON.ico",
        share="--share" in sys.argv,
        inbrowser="--open" in sys.argv,
        server_port=port,
    )

def get_port_from_args():
    if "--port" in sys.argv:
        port_index = sys.argv.index("--port") + 1
        if port_index < len(sys.argv):
            return int(sys.argv[port_index])
    return DEFAULT_PORT

if __name__ == "__main__":
    port = get_port_from_args()
    for _ in range(MAX_PORT_ATTEMPTS):
        try:
            launch_gradio(port)
            break
        except OSError:
            print(
                f"Failed to launch on port {port}, trying again on port {port - 1}..."
            )
            port -= 1
        except Exception as error:
            print(f"An error occurred launching Gradio: {error}")
            break
