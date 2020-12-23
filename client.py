import mysql.connector
from mysql.connector import Error
import os
from tabulate import tabulate


    ####################
####### Global scope #######
    ####################

#create connection to the database
mydb = mysql.connector.connect(
     host="localhost",
     user="root",
     passwd="Mysqlp@ssword123",
     allow_local_infile = "True"
    )
mycursor = mydb.cursor()    
global exit_code
    
    
    #################
####### Functions #######
    #################

#output in MySql Table style
def printTable(mydescription): 
    columns = []
    myresults = mycursor.fetchall()
    for cd in mydescription:
        columns.append(cd[0])      
    print(tabulate(myresults, headers=columns, tablefmt ='psql'))

#execute sql query
def executeQuery(command):   
    
    command = command + ' LIMIT 50'
    print(command)
    mycursor.execute(command)
    print("Command Executed")
    mydescription = mycursor.description                
    #print(mydescription)
    if mydescription is not None:
        printTable(mydescription)

#execute sql file
def executeSQLFile(filename):
    fd = open(filename, 'r')
    sqlFile = fd.read()
    fd.close()
    sqlCommands = sqlFile.split(';')
    mycursor = mydb.cursor()
    for command in sqlCommands:
        try:
            if command.strip() != '': #and  not re.match(r'-- ', command):
                executeQuery(command)
        except Error as msg:
            print("Command skipped: ", msg)
        mydb.commit()

        
#initiliaze db name ProjectDB on localhost
#load Movie Dataset into ProjectDB
def initDB():    
    print("Loading Database")
    #ans = input("Do you want to use existing database, y/n?  ")
    ans = 'y'
    
    if ans == "y":      
        print("Using existing database ProjectDB...")
        mycursor.execute('USE ProjectDB')
    else:
        #create initial database by executing sql file
        print("Creating fresh database...")
        mycursor.execute('SET GLOBAL local_infile=1')
        executeSQLFile('load_database.sql')
        
        
    
def displayMainMenu():
    print()
    print(" — — — — MENU — — — -")
    
    #by keyworkds, ratings, production companies, genres, cast/crew, character, title, language, budget, revenue
    #search movies of the genres that have been highly rated by the user
    #search for movies that have received good comments
    #search movies that other users have also commented in similar words
    #find movies that are being popular in the user’s location preference
    print(" 1. Search Movies") 
    
    #write comments/rating for the movies
    print(" 2. Write Reviews and Rate Movies")
    
    #find movies similar to the ones that the user has watched in the past
    #link users based on their comments and suggest movies to be watched together
    print(" 3. Suggest Movies") 
    
    #view older ratings and reviews
    print(" 4. View ratings and reviews")
    print(" 5. Exit")
    print(" — — — — — — — — — — ")

# exit function
# 5 to exit
# Else invalid

def exit():
    n = int(input(" Press 5 to exit : "))
    if n == 5:
        os.system("clear") # For Un*x
        run()
    else:
        print(" Invalid Option")
        exit()


#######################
# USER REGISTRATION
#######################

def registerUser():
    mycursor = mydb.cursor()
    print("\n — — — User Registration — — — ")
    
    name = input("Enter user name : ")
    age = int(input("Enter user age : "))
    telNo = int(input("Enter user contact number : "))
    #user id is auto generated at the db level
    sql = "INSERT INTO USER (NAME,AGE,TELEPHONE_NUMBER) VALUES (%s,%s,%s)"
    val = (name,age,telNo)
    mycursor.execute(sql,val)
    mydb.commit()
    print(" — — — Success — — — \n")
    exit()

########################
### Fetch all users
##########################

def getAllUsers():    
    mycursor = mydb.cursor()
    print(" — — — All Users — — — \n")
    query = "SELECT DISTINCT userID, username FROM users"
    executeQuery(query)

    '''
    mycursor.execute("SELECT * FROM USER")
    userList = mycursor.fetchall()
    i = 0
    for user in userList:
        i += 1
        print(" — — — User ",i," — — -")
        print(" Username : ", user[1])
        print(" Age : ", user[2])
        print(" Contact Number : ", user[3])
        print("\n")
        print(" — — — SUCCESS — — — \n")
    exit()
    '''


########################
### Fetch all posts
########################

def getAllPosts(): 
    mycursor = mydb.cursor()
    print(" — — — All Posts — — — \n")
    mycursor.execute("SELECT * FROM POST")
    postList = mycursor.fetchall()
    i = 0
    for post in postList:
        i += 1
        print(" — — — Post ",i," — — -")
        print(" Caption : ", post[1])
        val = post[3]
        sql = "SELECT * FROM USER WHERE ID=" + str(val)
        
        mycursor.execute(sql)
        user = mycursor.fetchall()
        
        print(" User ID : ", post[3])
        print(" User Name : ", user[0][1])
        print(" Image Url : ", post[2])
        print("\n")
    print(" — — — SUCCESS — — — \n")
    exit()


################################
#### Get all posts by a user
################################


def getAllPostsByUser():
    mycursor = mydb.cursor()
    print(" — — — Get All Posts By User — — — \n")
    n = int(input("Enter User ID : "))
    sql = "SELECT * FROM USER WHERE ID=" + str(n)
    mycursor.execute(sql)
    user = mycursor.fetchall()
    if len(user) == 0:
        print(" The user id is not exits")
    else:
        print(" — — — User — — -")
        print(" Username : ", user[0][1])
        print(" Age : ", user[0][2])
        print(" Contact Number : ", user[0][3])
        print("\n")
        print(" — — — ",user[0][1],"\"s All Posts — — — \n")
        sql = "SELECT * FROM POST WHERE USER_ID=" + str(n)
        mycursor.execute(sql)
        postList = mycursor.fetchall()
        i = 0
        for post in postList:
            i += 1
            print("— — — Post ",i," — — -")
            print(" Caption : ", post[1])
            print(" Description : ", post[2])
            print("\n")
        if len(postList) == 0:
            print(" — — — No posts available — — -")
            
        print("— — — SUCCESS — — — \n")
        exit()



# Run Execution Function
def run():
    global exit_code    
    displayMainMenu()
    
    while(not exit_code):    
        
        user_input = input("Enter options: ")
        while user_input == "":
            user_input = input("Enter options: ")
        print()
        n = int(user_input)
        if n == 1:
            searchMovies()
            displayMainMenu()
        elif n == 2:
            rateMovies()
            displayMainMenu()
        elif n == 3:
            suggestMovies()
            displayMainMenu()
        elif n == 4:
            viewRatings()
            displayMainMenu()
        elif n == 5:
            exit_code=True
        else:
            print("Invalid Selection. Try Again!!!")


# Menu 1. Search Movies
def searchMovies():
    os.system("clear")
    print(" — — — — 1. Search Movies — — — — ")
    user_title = input('Enter movie name: ')
    user_genre = input('Enter genre: ')
    user_keyword = input('Enter keywords: ')
    user_input = input('Choose an option: 1. Match all keywords or, 2. Match any keyword: ')  

    subquery1 = '(SELECT DISTINCT movieID FROM movies WHERE title LIKE \'%{}%\')'.format(user_title) 
    subquery2 = '(SELECT DISTINCT movieID FROM genres WHERE genre LIKE \'%{}%\')'.format(user_genre)
    subquery3 = '(SELECT DISTINCT movieID FROM keywords WHERE keyword LIKE \'%{}%\')'.format(user_keyword)
    
    if int(user_input)==1:
        query = 'SELECT DISTINCT * FROM (({} AS table1 INNER JOIN {} AS table2 ON table1.movieID=table2.movieID) AS table3 INNER JOIN {} AS table4 ON table3.movieID=table4.movieID)'.format(subquery1, subquery2, subquery3)   
    else:
        query = 'SELECT DISTINCT * FROM (({} AS table1 OUTER JOIN {} AS table2 ON table1.movieID=table2.movieID) AS table3 OUTER JOIN {} AS table4 ON table3.movieID=table4.movieID)'.format(subquery1, subquery2, subquery3) 

    print(query)
    executeQuery(query)

    #'SELECT DISTINCT * FROM (({} AS table1 INNER JOIN {} AS table2 ON table1.movieID=table2.movieID) AS table3 INNER JOIN {} AS table4 ON table3.movieID=table4.movieID)'.format(subquery1, subquery2, subquery3)


# Menu 2. Rate Movies
def rateMovies():
    pass 


# Menu 3. Suggest Movies
def suggestMovies():
    pass


# Menu 4. View ratings
def viewRatings():
    getAllUsers()


# Menu 5. exit
def exitProgram():
    pass

#main_program
if __name__ == "__main__":
    exit_code=False
    initDB()
    run()
    if (mydb.is_connected()):
        mydb.close()
        mycursor.close()
        print(" — — — Exiting — — — ")
        print("MySQL connection is closed.")
        print("Good Bye")
        print()


### Unused codes
'''
#Options to choose from localhost or uwaterloo
print("Select the server:\n1. Local Host\n2. UWaterloo")

if input() == 1:
    print("Local Host")
    mydb = mysql.connector.connect(
     host="localhost",
     user="root",
     passwd="Mysqlp@ssword123"
    )
else:
    print("Using marmoset04.shoshin.uwaterloo")
    mydb = mysql.connector.connect(
     host="marmoset04.shoshin.uwaterloo.ca", #localhost",
     user="kkhadka", #root",
     passwd="password656" #Mysqlp@ssword123"
    )
mycursor = mydb.cursor()
'''