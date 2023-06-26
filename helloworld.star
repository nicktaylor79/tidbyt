load("http.star", "http")
load("encoding/csv.star", "csv")
load("encoding/json.star", "json")
load("render.star", "render")
load("schema.star", "schema")
load("encoding/base64.star", "base64")


def main(config):
    sheet = fetch_sheet()

    if not sheet:
        return render.Root(
            child = render.Text("Could not fetch heating data")
        )

    rooms=sheet[0][1:]
    temps=sheet[1][1:]
    print(rooms)
    print(temps)
    print("testing")
    print(sheet[2][1:])

    col1 = []
    col2 = []
    for rw in rooms:
        col1.append(render.Marquee(width=50, child=render.Text(content = rw, font="tom-thumb")))
    

    for rw in temps:
        col2.append(render.Text(content=rw, font="tom-thumb"))
    
    columns = []    
    columns.append(
        render.Column(
            main_align = "space_between",
            cross_align = "left",
            children = col1 
        )
    )
    columns.append(
        render.Column(
            main_align = "space_between",
            cross_align = "right",
            children = col2
        )
    )


    return render.Root(
        child = render.Row(
            children = columns
        )
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
    rooms=[]
    temps=[]
    roomtemps=[]
    for csvrow in csv.read_all(heating_csv):
        rooms.append(csvrow[0])
        temps.append(csvrow[1])
        roomtemps.append(csvrow)
    return rooms,temps, roomtemps


    

    