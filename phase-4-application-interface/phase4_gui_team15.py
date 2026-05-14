#######################################################################
# Code was created using PyQT5 and pymysql documentation from CS 2316 #
#######################################################################
#####################         
# Import Statements #
#####################
import sys
from PyQt5.QtWidgets import QApplication, QWidget, QPushButton, QVBoxLayout, QHBoxLayout, QTextEdit, QLineEdit, QLabel, QStackedWidget, QSizePolicy, QTableWidget, QTableWidgetItem
import pymysql
from PyQt5.QtCore import Qt
from PyQt5.QtGui import QPalette, QColor
import pymysql

#####################################         
# Create GUI for adding an Airplane #
#####################################
class add_airplane(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Add Airplane") # Create the name of the window

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Add Airplane")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Airline ID"] = QLineEdit()
        self.inputs["Tail Num"] = QLineEdit()
        self.inputs["Seat Cap"] = QLineEdit()
        self.inputs["Speed"] = QLineEdit()
        self.inputs["Location ID"] = QLineEdit()
        self.inputs["Plane Type"] = QLineEdit()
        self.inputs["Maintained"] = QLineEdit()
        self.inputs["Model"] = QLineEdit()
        self.inputs["Neo"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Airline ID"))
        hbox1.addWidget(self.inputs["Airline ID"])
        hbox1.addWidget(QLabel("Tail Num"))
        hbox1.addWidget(self.inputs["Tail Num"])
        hbox1.addWidget(QLabel("Seat Cap"))
        hbox1.addWidget(self.inputs["Seat Cap"])

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("Speed"))
        hbox2.addWidget(self.inputs["Speed"])
        hbox2.addWidget(QLabel("Location ID"))
        hbox2.addWidget(self.inputs["Location ID"])
        hbox2.addWidget(QLabel("Plane Type"))
        hbox2.addWidget(self.inputs["Plane Type"])

        hbox3 = QHBoxLayout()
        hbox3.addWidget(QLabel("Maintained"))
        hbox3.addWidget(self.inputs["Maintained"])
        hbox3.addWidget(QLabel("Model"))
        hbox3.addWidget(self.inputs["Model"])
        hbox3.addWidget(QLabel("Neo"))
        hbox3.addWidget(self.inputs["Neo"])

        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        vbox.addLayout(hbox3)

        # Create "Add" Button
        button = QPushButton("Add", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Airline ID"].text()).strip().lower() == "null":
                airline_id = None
            else: 
                airline_id = self.inputs["Airline ID"].text().strip()

            if (self.inputs["Tail Num"].text()).strip().lower() == "null":
                tail_num = None
            else: 
                tail_num = self.inputs["Tail Num"].text().strip()

            if (self.inputs["Seat Cap"].text()).strip().lower() == "null":
                seat_cap = None
            else: 
                seat_cap = int(self.inputs["Seat Cap"].text().strip())

            if (self.inputs["Speed"].text()).strip().lower() == "null":
                speed = None
            else: 
                speed = int(self.inputs["Speed"].text().strip())
            
            if (self.inputs["Location ID"].text()).strip().lower() == "null":
                location_id = None
            else: 
                location_id = self.inputs["Location ID"].text().strip()

            if (self.inputs["Plane Type"].text()).strip().lower() == "null":
                plane_type = None
            else: 
                plane_type = self.inputs["Plane Type"].text().strip()

            if (self.inputs["Maintained"].text().strip()).lower() == "true" or (self.inputs["Maintained"].text().strip()).lower() == "1":
                maintained = True 
            elif (self.inputs["Maintained"].text().strip()).lower() == "false" or (self.inputs["Maintained"].text().strip()).lower() == "0":
                maintained = False
            elif (self.inputs["Maintained"].text()).strip().lower() == "null":
                maintained = None
            else:
                maintained = self.inputs["Maintained"].text()

            if (self.inputs["Model"].text()).strip().lower() == "null":
                model = None
            else: 
                model = self.inputs["Model"].text().strip()

            if (self.inputs["Neo"].text()).strip().lower() == "true" or (self.inputs["Neo"].text()).strip().lower() == "1":
                neo = True 
            elif (self.inputs["Neo"].text()).strip().lower() == "false" or (self.inputs["Neo"].text()).strip().lower() == "0":
                neo = False 
            elif (self.inputs["Neo"].text()).strip().lower() == "null":
                neo = None
            else: neo = self.inputs["Neo"].strip().text()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("add_airplane", (airline_id, tail_num, seat_cap, speed, location_id, plane_type, maintained, model, neo))
            conn.commit()

            self.output.setText("Airplane has been added and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as e:
            self.output.setText(str(e))

####################################          
# Create GUI for adding an Airport #
####################################
class add_airport(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Add Airport") # Create the name of the window

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Add Airport")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Airport ID"] = QLineEdit()
        self.inputs["Airport Name"] = QLineEdit()
        self.inputs["City"] = QLineEdit()
        self.inputs["State"] = QLineEdit()
        self.inputs["Country"] = QLineEdit()
        self.inputs["Location ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Airport ID"))
        hbox1.addWidget(self.inputs["Airport ID"])
        hbox1.addWidget(QLabel("Airport Name"))
        hbox1.addWidget(self.inputs["Airport Name"])
        hbox1.addWidget(QLabel("City"))
        hbox1.addWidget(self.inputs["City"])

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("State"))
        hbox2.addWidget(self.inputs["State"])
        hbox2.addWidget(QLabel("Country"))
        hbox2.addWidget(self.inputs["Country"])
        hbox2.addWidget(QLabel("Location ID"))
        hbox2.addWidget(self.inputs["Location ID"])

        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)

        # Create "Add" Button
        button = QPushButton("Add", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Airport ID"].text()).strip().lower() == "null":
                airport_id = None
            else: 
                airport_id = self.inputs["Airport ID"].text().strip()

            if (self.inputs["Airport Name"].text()).strip().lower() == "null":
                airport_name = None
            else: 
                airport_name = self.inputs["Airport Name"].text().strip()

            if (self.inputs["City"].text()).strip().lower() == "null":
                city = None
            else: 
                city = self.inputs["City"].text().strip()
            
            if (self.inputs["State"].text()).strip().lower() == "null":
                state = None
            else: 
                state = self.inputs["State"].text().strip()
            
            if (self.inputs["Country"].text()).strip().lower() == "null":
                country = None
            else: 
                country = self.inputs["Country"].text().strip()
            
            if (self.inputs["Location ID"].text()).strip().lower() == "null":
                location_id = None
            else: 
                location_id = self.inputs["Location ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("add_airport", (airport_id, airport_name, city, state, country, location_id))
            conn.commit()

            self.output.setText("Airport has been added and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as e:
            self.output.setText(str(e))

##################################        
# Create GUI for adding a Person #
##################################
class add_person(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Add Person") # Create the name of the window

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Add Person")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Person ID"] = QLineEdit()
        self.inputs["First Name"] = QLineEdit()
        self.inputs["Last Name"] = QLineEdit()
        self.inputs["Location ID"] = QLineEdit()
        self.inputs["Tax ID"] = QLineEdit()
        self.inputs["Experience"] = QLineEdit()
        self.inputs["Miles"] = QLineEdit()
        self.inputs["Funds"] = QLineEdit()        

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Person ID"))
        hbox1.addWidget(self.inputs["Person ID"])
        hbox1.addWidget(QLabel("First Name"))
        hbox1.addWidget(self.inputs["First Name"])
        hbox1.addWidget(QLabel("Last Name"))
        hbox1.addWidget(self.inputs["Last Name"])

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("Location ID"))
        hbox2.addWidget(self.inputs["Location ID"])
        hbox2.addWidget(QLabel("Tax ID"))
        hbox2.addWidget(self.inputs["Tax ID"])
        hbox2.addWidget(QLabel("Experience"))
        hbox2.addWidget(self.inputs["Experience"])

        hbox3 = QHBoxLayout()
        hbox3.addWidget(QLabel("Miles"))
        hbox3.addWidget(self.inputs["Miles"])
        hbox3.addWidget(QLabel("Funds"))
        hbox3.addWidget(self.inputs["Funds"])

        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        vbox.addLayout(hbox3)
        
        # Create "Add" Button
        button = QPushButton("Add", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Person ID"].text()).strip().lower() == "null":
                person_id = None
            else: 
                person_id = self.inputs["Person ID"].text().strip()

            if (self.inputs["First Name"].text()).strip().lower() == "null":
                first_name = None
            else: 
                first_name = self.inputs["First Name"].text().strip()

            if (self.inputs["Last Name"].text()).strip().lower() == "null":
                last_name = None
            else: 
                last_name = self.inputs["Last Name"].text().strip()
            
            if (self.inputs["Location ID"].text()).strip().lower() == "null":
                location_id = None
            else: 
                location_id = self.inputs["Location ID"].text().strip()
            
            if (self.inputs["Tax ID"].text()).strip().lower() == "null":
                tax_id = None
            else: 
                tax_id = self.inputs["Tax ID"].text().strip()

            if (self.inputs["Experience"].text()).strip().lower() == "null":
                experience = None
            else: 
                experience = int(self.inputs["Experience"].text().strip())

            if (self.inputs["Miles"].text()).strip().lower() == "null":
                miles = None
            else: 
                miles = int(self.inputs["Miles"].text().strip())  

            if (self.inputs["Funds"].text()).strip().lower() == "null":
                funds = None
            else: 
                funds = int(self.inputs["Funds"].text().strip())    

            conn = pymysql.connect(
                host = "localhost",
                user = "root", 
                password = "password", # Insert your mySQL password
                db = "flight_tracking" 
            )

            cursor = conn.cursor()
            cursor.callproc("add_person", (person_id, first_name, last_name, location_id, tax_id, experience, miles, funds))
            conn.commit()

            self.output.setText("Person has been added and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as e:
            self.output.setText(str(e))

################################################       
# Create GUI for Grant or Revoke Pilot License #
################################################
class grant_or_revoke_pilot_license(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Grant or Revoke Pilot License")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Grant or Revoke Pilot License")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Person ID"] = QLineEdit()
        self.inputs["License"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Person ID"))
        hbox1.addWidget(self.inputs["Person ID"])
        hbox1.addWidget(QLabel("License"))
        hbox1.addWidget(self.inputs["License"])

        vbox.addLayout(hbox1)

        # Create "Add / Revoke" Button
        button = QPushButton("Add / Revoke", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Person ID"].text()).strip().lower() == "null":
                person_id = None
            else: 
                person_id = self.inputs["Person ID"].text().strip()

            if (self.inputs["License"].text()).strip().lower() == "null":
                license = None
            else: 
                license = self.inputs["License"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("grant_or_revoke_pilot_license", (person_id, license))
            conn.commit()

            self.output.setText("Pilot license has been granted or revoked and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

###############################       
# Create GUI for Offer Flight #
###############################
class offer_flight(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Offer Flight") # Create the name of the window

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Offer Flight")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()
        self.inputs["Route ID"] = QLineEdit()
        self.inputs["Support Airline"] = QLineEdit()
        self.inputs["Support Tail"] = QLineEdit()
        self.inputs["Progress"] = QLineEdit()
        self.inputs["Next Time"] = QLineEdit()
        self.inputs["Cost"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])
        hbox1.addWidget(QLabel("Route ID"))
        hbox1.addWidget(self.inputs["Route ID"])
        hbox1.addWidget(QLabel("Support Airline"))
        hbox1.addWidget(self.inputs["Support Airline"])

        hbox2 = QHBoxLayout()
        hbox2.addWidget(QLabel("Support Tail"))
        hbox2.addWidget(self.inputs["Support Tail"])
        hbox2.addWidget(QLabel("Progress"))
        hbox2.addWidget(self.inputs["Progress"])
        hbox2.addWidget(QLabel("Next Time"))
        hbox2.addWidget(self.inputs["Next Time"])

        hbox3 = QHBoxLayout()
        hbox3.addWidget(QLabel("Cost"))
        hbox3.addWidget(self.inputs["Cost"])
   
        vbox.addLayout(hbox1)
        vbox.addLayout(hbox2)
        vbox.addLayout(hbox3)
        
        # Create "Add" Button
        button = QPushButton("Add", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            if (self.inputs["Route ID"].text()).strip().lower() == "null":
                route_id = None
            else: 
                route_id = self.inputs["Route ID"].text().strip()

            if (self.inputs["Support Airline"].text()).strip().lower() == "null":
                support_airline = None
            else: 
                support_airline = self.inputs["Support Airline"].text().strip()

            if (self.inputs["Support Tail"].text()).strip().lower() == "null":
                support_tail = None
            else: 
                support_tail = self.inputs["Support Tail"].text().strip()

            if (self.inputs["Progress"].text()).strip().lower() == "null":
                progress = None
            else: 
                progress = int(self.inputs["Progress"].text().strip())

            if (self.inputs["Next Time"].text()).strip().lower() == "null":
                next_time = None
            else: 
                next_time = self.inputs["Next Time"].text().strip()
            
            if (self.inputs["Cost"].text()).strip().lower() == "null":
                cost = None
            else: 
                cost = int(self.inputs["Cost"].text().strip())
            
            conn = pymysql.connect(
                host = "localhost",
                user = "root", 
                password = "password", # Insert your mySQL password
                db = "flight_tracking" 
            )

            cursor = conn.cursor()
            cursor.callproc("offer_flight", (flight_id, route_id, support_airline, support_tail, progress, next_time, cost))
            conn.commit()

            self.output.setText("Offer flight has been added and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as e:
            self.output.setText(str(e))

#################################        
# Create GUI for Flight Landing #
#################################
class flight_landing(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Flight Landing")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Flight Landing")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])

        vbox.addLayout(hbox1)

        # Create "Land" Button
        button = QPushButton("Land", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("flight_landing", (flight_id,))
            conn.commit()

            self.output.setText("Flight has been landed and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

#################################        
# Create GUI for Flight Takeoff #
#################################
class flight_takeoff(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Flight Takeoff")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Flight Takeoff")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])

        vbox.addLayout(hbox1)

        # Create "Takeoff" Button
        button = QPushButton("Takeoff", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("flight_takeoff", (flight_id,))
            conn.commit()

            self.output.setText("Flight has taken off and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

###################################       
# Create GUI for Passengers Board #
###################################
class passengers_board(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Passengers Board")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Passengers Board")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])

        vbox.addLayout(hbox1)

        # Create "Board" Button
        button = QPushButton("Board", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("passengers_board", (flight_id,))
            conn.commit()

            self.output.setText("Passengers have boarded and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

#######################################       
# Create GUI for Passengers Disembark #
#######################################
class passengers_disembark(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Passengers Disembark")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Passengers Disembark")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])

        vbox.addLayout(hbox1)

        # Create "Disembark" Button
        button = QPushButton("Disembark", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("passengers_disembark", (flight_id,))
            conn.commit()

            self.output.setText("Passengers have disembarked and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

###############################       
# Create GUI for Assign Pilot #
###############################
class assign_pilot(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Assign Pilot")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Assign Pilot")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()
        self.inputs["Person ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])
        hbox1.addWidget(QLabel("Person ID"))
        hbox1.addWidget(self.inputs["Person ID"])

        vbox.addLayout(hbox1)

        # Create "Assign" Button
        button = QPushButton("Assign", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            if (self.inputs["Person ID"].text()).strip().lower() == "null":
                person_id = None
            else: 
                person_id = self.inputs["Person ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("assign_pilot", (flight_id, person_id))
            conn.commit()

            self.output.setText("Pilot has been assigned and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

###############################       
# Create GUI for Recycle Crew #
###############################
class recycle_crew(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Recycle Crew")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Recycle Crew")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])

        vbox.addLayout(hbox1)

        # Create "Recycle" Button
        button = QPushButton("Recycle", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("recycle_crew", (flight_id,))
            conn.commit()

            self.output.setText("Crew has been recycled and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

################################      
# Create GUI for Retire Flight #
################################
class retire_flight(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Retire Flight")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Retire Flight")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        self.inputs["Flight ID"] = QLineEdit()

        hbox1 = QHBoxLayout()
        hbox1.addWidget(QLabel("Flight ID"))
        hbox1.addWidget(self.inputs["Flight ID"])

        vbox.addLayout(hbox1)

        # Create "Retire" Button
        button = QPushButton("Retire", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:
            if (self.inputs["Flight ID"].text()).strip().lower() == "null":
                flight_id = None
            else: 
                flight_id = self.inputs["Flight ID"].text().strip()

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("retire_flight", (flight_id,))
            conn.commit()

            self.output.setText("Flight has been retired and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

###################################    
# Create GUI for Simulation Cycle #
###################################
class simulation_cycle(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.inputs = {}
        self.setWindowTitle("Procedure: Simulation Cycle")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox = QHBoxLayout()
        label = QLabel("Simulation Cycle")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox.addWidget(label)
        vbox.addLayout(hbox)

        # Create "Next Step" Button
        button = QPushButton("Next Step", self)
        button.clicked.connect(self.call_procedure)
        vbox.addWidget(button)

        # Create Output Text Area 
        self.output = QTextEdit(self)
        self.output.setReadOnly(True)
        vbox.addWidget(self.output)

        # Create "Back" Button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def call_procedure(self):
        try:

            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password", # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.callproc("simulation_cycle")
            conn.commit()

            self.output.setText("Cycle has been simulated and stored procedure executed successfully.")

            cursor.close()
            conn.close()

        except Exception as i:
            self.output.setText(str(i))

##################################### 
# Create GUI for Flights in the Air #
#####################################         
class flights_in_the_air(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.setWindowTitle("View: Flights in the Air")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox1 = QHBoxLayout()
        label = QLabel("Flights in the Air")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox1.addWidget(label)
        vbox.addLayout(hbox1)

        # Create "Load View" Button
        button = QPushButton("Load View", self)
        button.clicked.connect(self.load_view)
        vbox.addWidget(button)

        # Create Output Table Area 
        self.table = QTableWidget()
        vbox.addWidget(self.table)

        # Create "Back" button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def load_view(self):
        try:
            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password",  # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.execute("select * from flights_in_the_air")
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description]

            # Setup GUI display table
            self.table.setColumnCount(len(headers))
            self.table.setHorizontalHeaderLabels(headers)
            self.table.setRowCount(len(rows))

            for row_idx, row_data in enumerate(rows):
                for col_idx, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(row_idx, col_idx, item)

            cursor.close()
            conn.close()

        except Exception as e:
            self.table.setItem(0, 0, QTableWidgetItem(str(e)))

########################################
# Create GUI for Flights on the Ground #
########################################        
class flights_on_the_ground(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.setWindowTitle("View: Flights on the Ground")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox1 = QHBoxLayout()
        label = QLabel("Flights on the Ground")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox1.addWidget(label)
        vbox.addLayout(hbox1)

        # Create "Load View" Button
        button = QPushButton("Load View", self)
        button.clicked.connect(self.load_view)
        vbox.addWidget(button)

        # Create Output Table Area 
        self.table = QTableWidget()
        vbox.addWidget(self.table)

        # Create "Back" button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def load_view(self):
        try:
            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password",  # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.execute("select * from flights_on_the_ground")
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description]

            # Setup GUI display table
            self.table.setColumnCount(len(headers))
            self.table.setHorizontalHeaderLabels(headers)
            self.table.setRowCount(len(rows))

            for row_idx, row_data in enumerate(rows):
                for col_idx, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(row_idx, col_idx, item)

            cursor.close()
            conn.close()

        except Exception as e:
            self.table.setItem(0, 0, QTableWidgetItem(str(e)))

####################################
# Create GUI for People in the Air #
####################################        
class people_in_the_air(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.setWindowTitle("View: People in the Air")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox1 = QHBoxLayout()
        label = QLabel("People in the Air")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox1.addWidget(label)
        vbox.addLayout(hbox1)

        # Create "Load View" Button
        button = QPushButton("Load View", self)
        button.clicked.connect(self.load_view)
        vbox.addWidget(button)

        # Create Output Table Area 
        self.table = QTableWidget()
        vbox.addWidget(self.table)

        # Create "Back" button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def load_view(self):
        try:
            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password",  # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.execute("select * from people_in_the_air")
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description]

            # Setup GUI display table
            self.table.setColumnCount(len(headers))
            self.table.setHorizontalHeaderLabels(headers)
            self.table.setRowCount(len(rows))

            for row_idx, row_data in enumerate(rows):
                for col_idx, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(row_idx, col_idx, item)

            cursor.close()
            conn.close()

        except Exception as e:
            self.table.setItem(0, 0, QTableWidgetItem(str(e)))

#######################################
# Create GUI for People on the Ground #
#######################################        
class people_on_the_ground(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.setWindowTitle("View: People on the Ground")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox1 = QHBoxLayout()
        label = QLabel("People on the Ground")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox1.addWidget(label)
        vbox.addLayout(hbox1)

        # Create "Load View" Button
        button = QPushButton("Load View", self)
        button.clicked.connect(self.load_view)
        vbox.addWidget(button)

        # Create Output Table Area 
        self.table = QTableWidget()
        vbox.addWidget(self.table)

        # Create "Back" button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def load_view(self):
        try:
            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password",  # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.execute("select * from people_on_the_ground")
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description]

            # Setup GUI display table
            self.table.setColumnCount(len(headers))
            self.table.setHorizontalHeaderLabels(headers)
            self.table.setRowCount(len(rows))

            for row_idx, row_data in enumerate(rows):
                for col_idx, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(row_idx, col_idx, item)

            cursor.close()
            conn.close()

        except Exception as e:
            self.table.setItem(0, 0, QTableWidgetItem(str(e)))

################################
# Create GUI for Route Summary #
################################        
class route_summary(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.setWindowTitle("View: Route Summary")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox1 = QHBoxLayout()
        label = QLabel("Route Summary")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox1.addWidget(label)
        vbox.addLayout(hbox1)

        # Create "Load View" Button
        button = QPushButton("Load View", self)
        button.clicked.connect(self.load_view)
        vbox.addWidget(button)

        # Create Output Table Area 
        self.table = QTableWidget()
        vbox.addWidget(self.table)

        # Create "Back" button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def load_view(self):
        try:
            conn = pymysql.connect(
                host = "localhost",
                user = "root",
                password = "password",  # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.execute("select * from route_summary")
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description]

            # Setup GUI display table
            self.table.setColumnCount(len(headers))
            self.table.setHorizontalHeaderLabels(headers)
            self.table.setRowCount(len(rows))

            for row_idx, row_data in enumerate(rows):
                for col_idx, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(row_idx, col_idx, item)

            cursor.close()
            conn.close()

        except Exception as e:
            self.table.setItem(0, 0, QTableWidgetItem(str(e)))

#####################################
# Create GUI for Alternate Airports #
#####################################        
class alternative_airports(QWidget):
    def __init__(self, go_home):
        super().__init__()
        self.go_home = go_home
        self.setWindowTitle("View: Alternate Airports")

        vbox = QVBoxLayout() # Define verticle layout for boxes

        # Create Title Row
        hbox1 = QHBoxLayout()
        label = QLabel("Alternate Airports")
        label.setAlignment(Qt.AlignCenter)
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        hbox1.addWidget(label)
        vbox.addLayout(hbox1)

        # Create "Load View" Button
        button = QPushButton("Load View", self)
        button.clicked.connect(self.load_view)
        vbox.addWidget(button)

        # Create Output Table Area 
        self.table = QTableWidget()
        vbox.addWidget(self.table)

        # Create "Back" button
        back_button = QPushButton("Back to Home")
        back_button.clicked.connect(self.go_home)
        vbox.addWidget(back_button)

        self.setLayout(vbox)

    def load_view(self):
        try:
            conn = pymysql.connect(
                host = "localhost", 
                user = "root",
                password = "password",  # Insert your mySQL password
                db = "flight_tracking"
            )

            cursor = conn.cursor()
            cursor.execute("select * from alternative_airports") # Query the View
            rows = cursor.fetchall()
            headers = [desc[0] for desc in cursor.description]

            # Setup GUI display table
            self.table.setColumnCount(len(headers))
            self.table.setHorizontalHeaderLabels(headers)
            self.table.setRowCount(len(rows))

            for i, row_data in enumerate(rows):
                for j, col_data in enumerate(row_data):
                    item = QTableWidgetItem(str(col_data))
                    self.table.setItem(i, j, item)

            cursor.close()
            conn.close()

        except Exception as e:
            self.table.setItem(0, 0, QTableWidgetItem(str(e)))

############################            
# Create GUI for Home Page #
############################
class HomePage(QWidget):
    def __init__(self, switch_to_pages):
        super().__init__()
        layout = QVBoxLayout() # Use the verticle layout  
        
        # Create dictionary with all Procedures
        procedures = {
            "Add Airplane": "add_airplane",
            "Add Airport": "add_airport",
            "Add Person": "add_person",
            "Grant or Revoke Pilot License": "grant_or_revoke_pilot_license",
            "Offer Flight": "offer_flight",
            "Flight Landing": "flight_landing",
            "Flight Takeoff": "flight_takeoff",
            "Passengers Board": "passengers_board",
            "Passengers Disembark": "passengers_disembark",
            "Assign Pilot": "assign_pilot",
            "Recycle Crew": "recycle_crew",
            "Retire Flight": "retire_flight",
            "Simulation Cycle": "simulation_cycle",
        } 

        # Create Title Row
        label = QLabel("Procedures")
        label.setAlignment(Qt.AlignCenter) 
        font = label.font()
        font.setPointSize(18)
        font.setBold(True)
        label.setFont(font)
        layout.addWidget(label)

        for (x, y) in procedures.items():
            button = QPushButton(x)
            button.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed) # Define sizing policy for buttons
            button.clicked.connect(lambda _, i = y: switch_to_pages(i))
            layout.addWidget(button)

        # Create dictionary with all Views
        views = {
            "Flights in the Air": "flights_in_the_air",
            "Flights on the Ground": "flights_on_the_ground",
            "People in the Air": "people_in_the_air",
            "People on the Ground": "people_on_the_ground",
            "Route Summary": "route_summary",
            "Alternate Airports": "alternative_airports"
        } 

        # Create Title Row
        label = QLabel("Views")
        label.setAlignment(Qt.AlignCenter) 
        font = label.font()
        font.setPointSize(18) # Change font size
        font.setBold(True) # Bold the font
        label.setFont(font)
        layout.addWidget(label)
        

        for (x, y) in views.items():
            button = QPushButton(x)
            button.setSizePolicy(QSizePolicy.Expanding, QSizePolicy.Fixed) # Define sizing policy for buttons
            button.clicked.connect(lambda _, i = y: switch_to_pages(i))
            layout.addWidget(button)

        self.setLayout(layout)

############################            
# Create GUI for Main Page #
############################
class MainWindow(QWidget):
    def __init__(self):
        super().__init__()
        self.setWindowTitle("Flight Tracking - Procedures and Views") # Create the name of the window
        self.stack = QStackedWidget()
        self.pages = {}
        self.resize(500, 700) # Resize the window

        self.layout = QVBoxLayout(self) # Use the verticle layout 

        # Add the GUI home page
        self.home_page = HomePage(self.switch_to_page)
        self.stack.addWidget(self.home_page)

        # Add each Procedure GUI page
        self.add_page("add_airplane", add_airplane(self.go_home))
        self.add_page("add_airport", add_airport(self.go_home))
        self.add_page("add_person", add_person(self.go_home))
        self.add_page("grant_or_revoke_pilot_license", grant_or_revoke_pilot_license(self.go_home))
        self.add_page("offer_flight", offer_flight(self.go_home))
        self.add_page("flight_landing", flight_landing(self.go_home))
        self.add_page("flight_takeoff", flight_takeoff(self.go_home))
        self.add_page("passengers_board", passengers_board(self.go_home))
        self.add_page("passengers_disembark", passengers_disembark(self.go_home))
        self.add_page("assign_pilot", assign_pilot(self.go_home))
        self.add_page("recycle_crew", recycle_crew(self.go_home))
        self.add_page("retire_flight", retire_flight(self.go_home))
        self.add_page("simulation_cycle", simulation_cycle(self.go_home))

        # Add each View GUI page
        self.add_page("flights_in_the_air", flights_in_the_air(self.go_home))
        self.add_page("flights_on_the_ground", flights_on_the_ground(self.go_home))
        self.add_page("people_in_the_air", people_in_the_air(self.go_home))
        self.add_page("people_on_the_ground", people_on_the_ground(self.go_home))
        self.add_page("route_summary", route_summary(self.go_home))
        self.add_page("alternative_airports", alternative_airports(self.go_home))

        self.layout.addWidget(self.stack)

    # Define function that adds pages
    def add_page(self, key, widget):
        self.pages[key] = widget
        self.stack.addWidget(widget)

    # Define function that switches pages
    def switch_to_page(self, key):
        if key in self.pages:
            self.stack.setCurrentWidget(self.pages[key])

    # Define function that allows to return to home page
    def go_home(self):
        self.stack.setCurrentWidget(self.home_page)

if __name__ == "__main__":
    app = QApplication(sys.argv)
    main = MainWindow()
    main.show()
    sys.exit(app.exec_())
