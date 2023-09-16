import requests
import json
import sys
import datetime, time
from datetime import datetime

# Replace 'abcd-qwer-asdf' with your personal API key
API_KEY = 'abcd-qwer-asdf'

# Base URL for N2YO API
BASE_URL = 'https://api.n2yo.com/rest/v1/satellite/'
# Norad id for satellite. 25544 = ISS
SATELLITE_ID = 25544
# Observer data: decimal degrees - latitude, longitude; meters - elevation.
LAT = 57.54161
LON = 25.42826
ALT = 0
# In seconds - length of time while satellite is visible in the sky
VISIBILITY = 60
# In days - how far into the future to predict ISS passovers, MAX = 10.
DAYS = 10

def check_internet_connection():
    while True:
        try:
            requests.get('https://www.google.com/').status_code
            break
        except:
            print("No internet connection!")
            time.sleep(5)
            pass

# Prepares and requests URL to get visual passes
def get_response():
    url = f"{BASE_URL}visualpasses/{SATELLITE_ID}/{LAT}/{LON}/{ALT}/{DAYS}/{VISIBILITY}&apiKey={API_KEY}"
    response = requests.get(url)
    return response

def check_response():
    response = get_response()
    if response.status_code != 200:
        print("Error code", response.status_code, "from API URL")
        sys.exit(1)
    return response.json()

def print_passes():
    visual_pass_response_json = check_response()
    print("ISS will be visible at:")
    for event in visual_pass_response_json['passes']:
        date_and_time = datetime.fromtimestamp(event['startUTC']).strftime('%d.%m.%Y %H:%M:%S')
        print(date_and_time, "for", event['endUTC']-event['startUTC'], "seconds")

if __name__ == "__main__":
    check_internet_connection()
    ## Get visual passes for ISS. Print out received information.
    # response = get_response()
    print("\nVisual Passes Response:")
    # print(response, "\n")
    print_passes()