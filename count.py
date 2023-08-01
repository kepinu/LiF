
search_term = "You receive:"
#open the log file
import sys,os,time,re,tkinter as tk
from datetime import date
from tkinter import messagebox
from functools import partial

today = date.today()
#print(today)
#sys.exit()
# Example usage:
directory_to_search = 'C:\\Games\\Life is Feudal MMO\\default\\game\\game\\eu\\logs\\' + str(today) + '\\'
labels = {}
count = {}
display = {}
button = {}
lastItem = ''
xp = 0

class App:
    def get_newest_file(directory):
        newest_file = None
        newest_mtime = 0

        for filename in os.listdir(directory):
            filepath = os.path.join(directory, filename)
            if os.path.isfile(filepath):
                file_mtime = os.path.getmtime(filepath)
                if file_mtime > newest_mtime:
                    newest_file = filepath
                    newest_mtime = file_mtime

        return newest_file

    def clearVar(itemName):
            #global lastItem
            #print(lastItem)
            del count[itemName] 
            display[itemName].destroy()
            display.pop(itemName)
            button[itemName].destroy()
            button.pop(itemName)

            return count   
    def clearAll():
        global count
        count = {}
        global display
        global button
        for disp in display.keys():
            display[disp].destroy()
        display = {}
        for butt in button.keys():
            button[butt].destroy()
        button = {}

    def __init__(self,file_path):
        # Set the initial file position to the end of the file
        file_position = 0
        

        # make gui
        global root
        root = tk.Tk()
        root.title("LiF Log Parser")
        root.geometry("300x150")
        clearAllButton = tk.Button(root,text = "Clear All",command=partial(App.clearAll))
        clearAllButton.pack()
        xpString = tk.StringVar()
        xpDisplay = tk.Label(root,textvariable=xpString)
        xpDisplay.pack() 
    
        while True:
            # Open the log file in read mode
            with open(file_path, 'r') as file:
                # Move to the previous file position
                file.seek(file_position)
                # Read all new content since the last position
                new_content = file.read()
                # Update the file_position to the current end of the file
                file_position = file.tell()

            # Process the new content (e.g., extract information or analyze logs)
            if new_content:
                for line in new_content.split("\n"):
                    if search_term in line:
                        itemName = re.sub("<spop>","",line.split("<spush><color:C65F5F>")[1])
                        itemCount = re.sub("<spop>","",line.split("<spush><color:C65F5F>")[2])
                        global lastItem
                        lastItem = itemName
                        if itemName in count.keys() :
                            count[itemName] += int(itemCount)
                            print("Label exists")                                                    
                            print(labels.keys())
                            labels[itemName].set(itemName + ' = ' + str(count[itemName]))

                            
                        else:
                            count[itemName] = int(itemCount)
                            print("Creating Label")
                            labels[itemName] = tk.StringVar()
                            labels[itemName].set(itemName + '=' + str(count[itemName]))
                            display[itemName] = tk.Label(root,textvariable=labels[itemName])
                            display[itemName].pack()
                            button[itemName] = tk.Button(root,text = "Clear",command=partial(App.clearVar,itemName))
                            button[itemName].pack()                    
                        print(itemName)  # You can replace this with your actual parsing logic
                        print(itemCount + "(" + str(count[itemName]) + ")")
                    elif "crafting experience" in line:
                        global xp
                        xp += float(re.sub("<spop>","",line.split("<spush><color:C65F5F>")[1]).split(' ')[0])
                        
                        xpString.set(str("{:,.2f}".format(xp)) + " XP Today")
                        
                                
                            

            # Introduce a delay before checking the file again (e.g., 1 second)
            time.sleep(1)
            #root.mainloop()
            root.update_idletasks()
            root.update()



if __name__ == "__main__":
    log_file_path = App.get_newest_file(directory_to_search)
    
    app = App(log_file_path)
    #App.parse_log_file(log_file_path,root)
    