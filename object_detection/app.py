# import cv2
# import cvlib as cv
# from cvlib.object_detection import draw_bbox
# from gtts import gTTS
# import os
# import json

# def perform_object_detection():
#     video = cv2.VideoCapture(0)
#     labels = []

#     frame_skip = 10  # Process every 10th frame
#     count = 0

#     while True:
#         ret, frame = video.read()
#         count += 1

#         if count % frame_skip != 0:
#             continue

#         bbox, label, conf = cv.detect_common_objects(frame)
#         op = draw_bbox(frame, bbox, label, conf)
#         cv2.imshow('Object Detection', op)

#         for itms in label:
#             if itms not in labels:
#                 labels.append(itms)

#         if cv2.waitKey(1) & 0xFF == ord('q'):
#             break

#     video.release()
#     cv2.destroyAllWindows()

#     sentences = [f"There is {label}" for label in labels]
#     sentence = ", and, ".join(sentences)
#     speech(sentence)

# def speech(text):
#     print(text)
#     language = "en"
#     output = gTTS(text=text, lang=language, slow=False)
#     current_directory = os.path.abspath(os.path.dirname(__file__))
#     sounds_directory = os.path.join(current_directory, 'sounds')
#     output_path = os.path.join(sounds_directory, 'output.mp3')
#     output.save(output_path)
#     os.system("mpg321 " + output_path)

# def main():
#     try:
#         perform_object_detection()
#         result = {'success': True}
#     except Exception as e:
#         print("Error:", str(e))
#         result = {'success': False, 'error': str(e)}
#     print(json.dumps(result))

# if __name__ == "__main__":
#     main()
import json
import cv2
import cvlib as cv
from cvlib.object_detection import draw_bbox
from gtts import gTTS
import os

def perform_object_detection(channel):
    video = cv2.VideoCapture(0)
    labels = []

    frame_skip = 10  # Process every 10th frame
    count = 0

    while True:
        ret, frame = video.read()
        count += 1

        if count % frame_skip != 0:
            continue

        bbox, label, conf = cv.detect_common_objects(frame)
        op = draw_bbox(frame, bbox, label, conf)

        for item in label:
            if item not in labels:
                labels.append(item)

        channel.send(json.dumps(labels))  # Send detected labels to Flutter

        cv2.imshow('Object Detection', op)

        if cv2.waitKey(1) & 0xFF == ord('q'):
            break

    video.release()
    cv2.destroyAllWindows()

    sentences = [f"There is {label}" for label in labels]
    sentence = ", and, ".join(sentences)
    speech(sentence)

def speech(text):
    print(text)
    language = "en"
    output = gTTS(text=text, lang=language, slow=False)
    current_directory = os.path.abspath(os.path.dirname(__file__))
    sounds_directory = os.path.join(current_directory, 'sounds')
    output_path = os.path.join(sounds_directory, 'output.mp3')
    output.save(output_path)
    os.system("mpg321 " + output_path)

def main():
    channel = "channel"
    try:
        perform_object_detection(channel)  # Pass the channel object to the function
        result = {'success': True}
    except Exception as e:
        print("Error:", str(e))
        result = {'success': False, 'error': str(e)}
    print(json.dumps(result))

if __name__ == "__main__":
    main()
