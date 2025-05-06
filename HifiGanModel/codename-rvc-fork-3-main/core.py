import os
import sys
from functools import lru_cache

now_dir = os.getcwd()
sys.path.append(now_dir)

current_script_directory = os.path.dirname(os.path.realpath(__file__))
logs_path = os.path.join(current_script_directory, "logs")

@lru_cache(maxsize=None)
def import_voice_converter():
    from rvc.infer.infer import VoiceConverter
    return VoiceConverter()

@lru_cache(maxsize=1)
def get_config():
    from rvc.configs.config import Config
    return Config()

def run_infer_script(
    pitch: int,
    filter_radius: int,
    index_rate: float,
    volume_envelope: int,
    protect: float,
    hop_length: int,
    f0_method: str,
    input_path: str,
    output_path: str,
    pth_path: str,
    index_path: str,
    split_audio: bool = False,
    f0_autotune: bool = False,
    f0_autotune_strength: float = 0.0,
    clean_audio: bool = False,
    clean_strength: float = 0.0,
    export_format: str = "wav",
    f0_file: str = "",
    embedder_model: str = "hubert_base",
    sid: int = 0,
):
    kwargs = {
        "audio_input_path": input_path,
        "audio_output_path": output_path,
        "model_path": pth_path,
        "index_path": index_path,
        "pitch": pitch,
        "filter_radius": filter_radius,
        "index_rate": index_rate,
        "volume_envelope": volume_envelope,
        "protect": protect,
        "hop_length": hop_length,
        "f0_method": f0_method,
        "split_audio": split_audio,
        "f0_autotune": f0_autotune,
        "f0_autotune_strength": f0_autotune_strength,
        "clean_audio": clean_audio,
        "clean_strength": clean_strength,
        "export_format": export_format,
        "f0_file": f0_file,
        "embedder_model": embedder_model,
        "sid": sid,
    }
    infer_pipeline = import_voice_converter()
    infer_pipeline.convert_audio(**kwargs)
    return f"File {input_path} inferred successfully.", output_path.replace(".wav", f".{export_format.lower()}")

def run_batch_infer_script(
    pitch: int,
    filter_radius: int,
    index_rate: float,
    volume_envelope: int,
    protect: float,
    hop_length: int,
    f0_method: str,
    input_folder: str,
    output_folder: str,
    pth_path: str,
    index_path: str,
    split_audio: bool = False,
    f0_autotune: bool = False,
    f0_autotune_strength: float = 0.0,
    clean_audio: bool = False,
    clean_strength: float = 0.0,
    export_format: str = "wav",
    f0_file: str = "",
    embedder_model: str = "hubert_base",
    sid: int = 0,
):
    os.makedirs(output_folder, exist_ok=True)
    files = [f for f in os.listdir(input_folder) if f.endswith((".wav", ".mp3", ".flac", ".ogg", ".m4a"))]
    for file in files:
        input_path = os.path.join(input_folder, file)
        output_path = os.path.join(output_folder, os.path.splitext(file)[0] + ".wav")
        run_infer_script(
            pitch=pitch,
            filter_radius=filter_radius,
            index_rate=index_rate,
            volume_envelope=volume_envelope,
            protect=protect,
            hop_length=hop_length,
            f0_method=f0_method,
            input_path=input_path,
            output_path=output_path,
            pth_path=pth_path,
            index_path=index_path,
            split_audio=split_audio,
            f0_autotune=f0_autotune,
            f0_autotune_strength=f0_autotune_strength,
            clean_audio=clean_audio,
            clean_strength=clean_strength,
            export_format=export_format,
            f0_file=f0_file,
            embedder_model=embedder_model,
            sid=sid,
        )
    return f"Batch inference completed for {len(files)} files."
