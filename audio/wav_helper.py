#!/usr/bin/python3

def extract_data(path):
  with open(path, "rb+") as stream:
    header = stream.read(44)
    data = stream.read()
  
  print('file header:\n')
  print(header)
  


extract_data('/home/glasser/toys/physc/physc/assets/jazz_piano_intro.wav')


