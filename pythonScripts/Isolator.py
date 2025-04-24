from pytube import YouTube
from spleeter.separator import Separator
from pydub import AudioSegment
import os

def download_youtube_audio(youtube_url, output_path='downloads'):
    if not os.path.exists(output_path):
        os.makedirs(output_path)

    yt = YouTube(youtube_url)
    audio_stream = yt.streams.filter(only_audio=True, file_extension='mp4').first()
    print(f"Downloading: {yt.title}...")
    audio_file = audio_stream.download(output_path=output_path)

    base, _ = os.path.splitext(audio_file)
    new_file = base + '.mp3'
    os.rename(audio_file, new_file)
    print(f"Downloaded and saved as: {new_file}")
    return new_file

def separate_vocals(audio_file, output_directory='output'):
    # Initialize the separator
    separator = Separator('spleeter:2stems')
    print("Separating vocals...")
    separator.separate_to_file(audio_file, output_directory)
    print(f"Vocals separated and saved in: {output_directory}")

def combine_tracks(vocals_path, instrumental_path, output_path='output'):
    vocals = AudioSegment.from_file(vocals_path)
    instrumental = AudioSegment.from_file(instrumental_path)
    
    combined = vocals.overlay(instrumental)
    
    if not os.path.exists(output_path):
        os.makedirs(output_path)
    
    output_file = os.path.join(output_path, 'combined_track.mp3')
    combined.export(output_file, format='mp3')
    print(f"Combined track saved as: {output_file}")
    return output_file

# Main function (Change these paths to my own)
def main():
    vocals_path = "love_yourself_es_output.wav" 
    instrumental_path = "loveyourselfintrumental.wav"  
    
    
    combined_track = combine_tracks(vocals_path, instrumental_path)
    print("Process completed successfully!")

if __name__ == "__main__":
    main()