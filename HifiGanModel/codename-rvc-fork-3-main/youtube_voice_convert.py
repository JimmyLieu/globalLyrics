import os
import sys
import yt_dlp
import torch
import subprocess
from pathlib import Path

# Add current directory to path
now_dir = os.getcwd()
sys.path.append(now_dir)

from core import run_infer_script

# Available embedder models
EMBEDDER_MODELS = [
    "hubert_base",
    "contentvec",
    "spin",
    "chinese-hubert-base",
    "japanese-hubert-base",
    "korean-hubert-base",
    "custom"
]

def get_available_embedder_models():
    """Get list of available embedder models"""
    return EMBEDDER_MODELS

def download_youtube_audio(url, output_dir="assets/audios"):
    """Download audio from YouTube URL"""
    os.makedirs(output_dir, exist_ok=True)
    
    ydl_opts = {
        'format': 'bestaudio/best',
        'postprocessors': [{
            'key': 'FFmpegExtractAudio',
            'preferredcodec': 'wav',
        }],
        'outtmpl': os.path.join(output_dir, '%(title)s.%(ext)s'),
    }
    
    with yt_dlp.YoutubeDL(ydl_opts) as ydl:
        info = ydl.extract_info(url, download=True)
        audio_path = os.path.join(output_dir, f"{info['title']}.wav")
        return audio_path

def separate_vocals(input_path, output_dir="assets/audios"):
    """Separate vocals from audio using Demucs"""
    # Install demucs if not already installed
    try:
        import demucs
    except ImportError:
        subprocess.run([sys.executable, "-m", "pip", "install", "demucs"])
    
    # Create output directory
    os.makedirs(output_dir, exist_ok=True)
    
    # Run demucs separation
    cmd = [
        sys.executable, "-m", "demucs",
        "--two-stems=vocals",
        "-n", "htdemucs",
        input_path,
        "-o", output_dir
    ]
    
    subprocess.run(cmd)
    
    # Get the separated vocals path
    base_name = os.path.splitext(os.path.basename(input_path))[0]
    vocals_path = os.path.join(output_dir, "htdemucs", base_name, "vocals.wav")
    return vocals_path

def convert_voice(
    input_path,
    model_path,
    index_path,
    output_dir="assets/audios",
    pitch=0,
    index_rate=0.3,
    protect=0.33,
    f0_method="rmvpe",
    embedder_model="hubert_base"
):
    """Convert voice using RVC"""
    os.makedirs(output_dir, exist_ok=True)
    
    # Generate output path
    base_name = os.path.splitext(os.path.basename(input_path))[0]
    output_path = os.path.join(output_dir, f"{base_name}_converted.wav")
    
    # Run inference
    run_infer_script(
        pitch=pitch,
        filter_radius=3,
        index_rate=index_rate,
        volume_envelope=1,
        protect=protect,
        hop_length=128,
        f0_method=f0_method,
        input_path=input_path,
        output_path=output_path,
        pth_path=model_path,
        index_path=index_path,
        split_audio=False,
        f0_autotune=False,
        f0_autotune_strength=0.0,
        clean_audio=False,
        clean_strength=0.0,
        export_format="wav",
        f0_file="",
        embedder_model=embedder_model,
        sid=0,
    )
    
    return output_path

def process_youtube_song(
    youtube_url,
    model_path,
    index_path,
    output_dir="assets/audios",
    pitch=0,
    index_rate=0.3,
    protect=0.33,
    f0_method="rmvpe",
    embedder_model="hubert_base"
):
    """Process a YouTube song through the entire pipeline"""
    print("1. Downloading audio from YouTube...")
    audio_path = download_youtube_audio(youtube_url, output_dir)
    print(f"Downloaded to: {audio_path}")
    
    print("\n2. Separating vocals...")
    vocals_path = separate_vocals(audio_path, output_dir)
    print(f"Vocals separated to: {vocals_path}")
    
    print("\n3. Converting voice...")
    converted_path = convert_voice(
        vocals_path,
        model_path,
        index_path,
        output_dir,
        pitch,
        index_rate,
        protect,
        f0_method,
        embedder_model
    )
    print(f"Voice converted to: {converted_path}")
    
    return converted_path

if __name__ == "__main__":
    # Print available embedder models
    print("Available embedder models:")
    for i, model in enumerate(EMBEDDER_MODELS, 1):
        print(f"{i}. {model}")
    
    # Get user input
    youtube_url = input("\nEnter YouTube URL: ")
    model_path = input("Enter path to model.pth: ")
    index_path = input("Enter path to model.index: ")
    
    # Get embedder model choice
    while True:
        try:
            choice = int(input(f"\nSelect embedder model (1-{len(EMBEDDER_MODELS)}): "))
            if 1 <= choice <= len(EMBEDDER_MODELS):
                embedder_model = EMBEDDER_MODELS[choice - 1]
                break
            else:
                print("Invalid choice. Please try again.")
        except ValueError:
            print("Please enter a number.")
    
    try:
        output_path = process_youtube_song(
            youtube_url,
            model_path,
            index_path,
            embedder_model=embedder_model
        )
        print(f"\nProcessing complete! Output saved to: {output_path}")
    except Exception as e:
        print(f"Error during processing: {str(e)}") 