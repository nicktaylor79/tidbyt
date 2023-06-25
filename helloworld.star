load("http.star", "http")
load("encoding/csv.star", "csv")
load("encoding/json.star", "json")
load("render.star", "render")
load("schema.star", "schema")




def main(config):
    sheet = fetch_sheet()

    if not sheet:
        return render.Root(
            child = render.Text("Could not fetch heating data")
        )
    
    
    print(sheet['room'])
    #print(sheet.values())
   
    return render.Root(
        child = render.Box(
            render.Column(
                cross_align="center",
                main_align = "center",
                children = [
                    render.Text(
                        content = "Heating Data",
                        font = "tb-8"
                    ),

                    render.Text(
                        content = sheet[ROOM[0]],
                        font = "6x13",
                    ),
                ],
            ),

        ),
    )





def fetch_sheet():
    resp = http.get("https://docs.google.com/spreadsheets/d/14mfvV8IdEpOOGlrlE5953IeacluDdTMfZUiZuKL9a2s/export?format=csv")
    if resp.status_code != 200:
        print("Could not fetch feed spec: ", resp.status_code)
        return None

    heating = process_heating(resp.body())
    #heating = resp.body()
    return heating 



ROOM = 'room'
CURRENT = 'currentemp'
TARGET = 'targettemp'

def process_heating(heating_csv):
    heats = {}
    for row in csv.read_all(heating_csv):
        heat = {
            ROOM: row[0],
            CURRENT: row[1],
            TARGET: row[2],
            }
        heats[heat[ROOM]] = heat 
    return heats


    

    