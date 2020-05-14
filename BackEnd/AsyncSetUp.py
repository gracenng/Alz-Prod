from aiohttp import web
from datetime import datetime
import time
import face_id
import asyncio
import base64
import os

time_stamp = 0

async def add_all_persisted_face_ids(): # needs to be done very 24 hours to initialize the face api person group
    await asyncio.sleep(10)
    
    global time_stamp
    time_stamp = datetime.now().day
    #print(time_stamp)
    
    for i in face_id.person: # add all the persisted-id's again
        face_id.add_face_with_stream(i, face_id.person[i]['image_stream'])

    if face_id.train() == "failed": # train the face client
        print("Please try again.") # train the face api

async def call_handle(request): # the root of the request where a face is registered
    try:  
        name = ( await request.post() ) ['name']
        bs64_image_stream = ( await request.post() ) ['image_stream']
        decoded_image_stream = base64.b64decode(bs64_image_stream)
        
        # comment this out
        '''
        imageFile =  open(r"nihalphoto2.jpg", "rb").read()
        bs64_image_stream2 = base64.b64encode(imageFile)
        print(bs64_image_stream2==bs64_image_stream)
        '''
        #print(decoded_image_stream==base64.b64decode(bs64_image_stream))
                
        print(face_id.add_face_with_stream(name, decoded_image_stream))

        #decoded = base64.decodebytes("")

        text = "Hello, " + name + ", your face has been registered!"
        
        asyncio.ensure_future(add_all_persisted_face_ids())

        return web.Response(text=text)
    except Exception as e:
        text = "There's an error, please try again!"
        
        raise Exception("there's an error", e)
        
        return web.Response(text=text)

async def identify_person(request): # identify the peroson    
    # don't train if already trained in the last 24 hours
    try:
        if time_stamp != datetime.now().day and (time_stamp-1) != datetime.now().day and (time_stamp+1) != datetime.now().day:
            await add_all_persisted_face_ids()

        bs64_image_stream = ( await request.post() ) ['image_stream']
        
        decoded_image_stream = base64.b64decode(bs64_image_stream)  

        # Comment these lines out
        #test_image_file =  open(r"nihalphoto.jpg", "r+b") 
        #decoded_image_stream = test_image_file.read()

        # send image stream to be identified
        person_details = face_id.identify_person( decoded_image_stream )

        if not person_details:
            print("Unindentified Person.")
            return web.Response( text = "Unindentified Person." )

        person_id = person_details.person_id
        name = str(face_id.face_client.large_person_group_person.get(face_id.group_id, person_id).name)    
        
        text = "The person being identified is " + name + " with " + str(round(person_details.confidence*100, 2)) + "%" + " confidence "
        
        print(text)
        return web.Response( text = text)
    except Exception as e:
        print(e)
        raise Exception("there's an error", e)
        return web.Response( text = "There's an error. Please try again. ")

async def home(request):
    return web.Response ( text = "Hello World" )

if __name__ == '__main__':  
    '''
    image_stream = open(r"nihalphoto.jpg", "r+b").read()
    encoding = base64.b64encode(image_stream)
    #print(type(image_stream)) # DO NOT WRITE THIS TO SCREEN
    '''    
    app = web.Application()
    app.add_routes([
        web.get('/', home),
        web.post('/add_person', call_handle),
        web.post('/identify_person', identify_person)
    ])
    port = int(os.environ.get("PORT", 5000))

    web.run_app(app, port=port)