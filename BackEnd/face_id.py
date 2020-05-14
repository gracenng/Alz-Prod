# face api documentation: https://docs.microsoft.com/en-us/azure/cognitive-services/face/quickstarts/python-sdk
from msrest.authentication import CognitiveServicesCredentials
from azure.cognitiveservices.vision.face import FaceClient
import Credentials
from azure.cognitiveservices.vision.face.models import TrainingStatusType
import time

group_id = "alz"
image_name = "nihalphoto.jpg"

# authentication
face_client = FaceClient(Credentials.ENDPOINT, CognitiveServicesCredentials(Credentials.SUBSCRIPTION_KEY))
person = {}

def list_face_ids():
    pass    

def mutlitple_faces(website_url):
    detected_faces = face_client.face.detect_with_url(website_url)
    for i in detected_faces:
        print(i.face_id)
    return detected_faces

def get_face_from_stream(image_stream):
    return face_client.face.detect_with_stream(image_stream)
    
def similar_faces(detected_faces, sample_face_id):
    # find similar faces
    sample_face_ids = list(map(lambda a: a.face_id, detected_faces))
    '''
    for i in detected_faces:
        sample_face_ids.append(i.face_id)
    '''
    similar_faces = face_client.face.find_similar(sample_face_id, face_ids=sample_face_ids)
    for i in similar_faces:
        print("similar faces: ", i)
    return similar_faces

def verify_faces(photo_id1, photo_id2):
    verify_faces = face_client.face.verify_face_to_face(photo_id1, photo_id2)
    print("Identical: " + str(verify_faces.is_identical) )
    print("Confidence: " + str(verify_faces.confidence) )

def create_person_group():
    # face_client.large_person_group.create("1", "Contacts", recognition_model='recognition_02') # create the person group
    face_client.large_person_group.create(group_id, group_id)

def delete_a_person_group():
    face_client.person_group.delete(group_id)

def create_person_in_person_group(name):
    person = face_client.large_person_group_person.create(group_id, name)
    return person.person_id

def list_person_in_person_group():
    for i in face_client.large_person_group_person.list(large_person_group_id=(group_id)):
        print(i)

def delete_all():
    for i in face_client.large_person_group_person.list(group_id):
        face_client.large_person_group_person.delete(group_id, i.person_id)

def add_face_with_url(url, name):
    if name not in person: # does not exist
        person_id = create_person_in_person_group(name)
        person[name] = person_id
    else: # exists
        person_id = person[name]
        
    face_client.large_person_group_person.add_face_from_url(group_id, person_id, url)

    return "Successful."

def add_face_with_stream(name, image_stream): # adds a face to the person group
    if name not in person: # does not exist
        person_id = create_person_in_person_group(name)
    else:
        person_id = person[name]['person_id']
        
    person[name] = {'person_id': person_id, 'image_stream':image_stream}

    # writing the image stream to the image file and opening the file for operations again
    imageFile =  open(image_name, "r+b")
    imageFile.write(image_stream)
    imageFile =  open(image_name, "r+b")

    face_client.large_person_group_person.add_face_from_stream(group_id, person_id, image=imageFile)
    
    return "Successful."

def train():
    print(person)
    face_client.large_person_group.train(group_id)

    while(True):
        training_status = face_client.large_person_group.get_training_status(group_id)
        print(training_status.status)
        
        if training_status.status is TrainingStatusType.succeeded:
            return "succeeded"
        elif training_status.status is TrainingStatusType.failed:
            return "failed"


def identify(face_id): # identifying the person
    results = face_client.face.identify(face_id, large_person_group_id=group_id)
    try:
        for i in results:
            for result in i.candidates:
                
                print("The result: ", result)

                return ( result )
    except Exception as e:
        print(str(e))
        return "none"

def add_sample_people():
    jfk_image = "https://www.biography.com/.image/t_share/MTQ1MzAyNzYzOTgxNTE0NTEz/john-f-kennedy---mini-biography.jpg"
    add_face_with_url(jfk_image, "JFK")
    add_face_with_url(jfk_image, "JFK2")
    add_face_with_url(jfk_image, "JFK3")

'''
    john_lennon_image = "https://upload.wikimedia.org/wikipedia/commons/e/ea/John_Lennon_1968_%28cropped%29.jpg"
    add_face_with_url(john_lennon_image, "Lennon")
    add_face_with_url(john_lennon_image, "Lennon2")
    add_face_with_url(john_lennon_image, "Lennon3")
    '''

def identify_person(image_stream):
    '''
    if not len(person) > 0:
        return "There is no one in the database"
    '''
    #list_person_in_person_group() # list all the people in the face api

    imageFile =  open(image_name, "r+b")
    imageFile.write(image_stream)
    imageFile =  open(image_name, "r+b")

    # print out the face ids and append to the array
    print("face ids: ")
    face_ids = []
    for face in face_client.face.detect_with_stream(imageFile):
        face_ids.append(face.face_id)
        print(face)
    
    # training the API
    return identify( face_ids )
    
    #jfk_image = "https://www.biography.com/.image/t_share/MTQ1MzAyNzYzOTgxNTE0NTEz/john-f-kennedy---mini-biography.jpg"

if __name__ == "__main__":
    # detect faces
   # detected_faces = detect_faces(website_url)

    # use a database to store face id's for a given day - if on same day, no reason to call
    # if not called yet on specific day, call and store all results
    # with given results, iterate throigh and identify with identify method
   # add_sample_people()
    '''
    sample_face_id = detected_faces[0].face_id

    count = 1

    print(detected_faces[0])
    print(detected_faces[1])

    similar_faces(detected_faces, sample_face_id)
    verify_faces("0f0d2558-dc66-4199-9b29-91e26c8e780b", "ae1004ac-1ceb-4946-958a-86a20c4e741b")
    '''    
    
    #list_person_in_person_group() # listing all the images in the face API
    #delete_all() # deleteing all the images in the face API

    #imageFile =  open(r"nihalphoto.jpg", "r+b") # TO DO - test this process works with file streams
    #print(add_face_with_stream("nihal", imageFile))

    #delete_all() # delete all the persons in a person group
    #identify_person()
    # the images to be added to the contact list

    #identify_person("") # to be edited
    
    # user journey - user adds image, we get image stream
    # add user details to some database with a list of their image streams
    # create a person group with the required image stream, with the name of the person
    # if the specified person already exists, add image to existing face-image array
    # train model in the background ?

    # when they click identify, we get image stream
    # get face ID from image stream
    # train the model with existing data and use face ID to identify person

    '''
    person['obj'] = {'person_id':1}
    person['obj'] = {'person_id':person['obj']['person_id'], 'name':'nihal'}
    person['obj2'] = {'person_id':person['obj']['person_id'], 'name':'nihal'}
    print(person)
    '''