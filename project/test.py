from flask import Flask,flash,render_template, request, redirect, url_for
import mysql.connector
from flask import session
import random

app = Flask(__name__)
app.secret_key = 'hello'


db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'dbms_project'
}

def connect_to_database():
    return mysql.connector.connect(**db_config)

@app.route('/')
def index():
    if 'logged_in' in session:
        user_role = session.get('user_role')
        if user_role == 'customer':
            return render_template('dashboard_customer.html')
        elif user_role == 'admin':
            return render_template('dashboard_admin.html')
    return render_template('dashboard.html')

@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        user_type = request.form.get('user_type')
      
        connection = connect_to_database()
        cursor = connection.cursor()

        if user_type == 'Customer':
            query = "SELECT * FROM customers WHERE username = %s AND password = %s"
            user_role = 'customer'
        
        else:
            query = "SELECT * FROM admins WHERE username = %s AND password = %s"
            user_role = 'admin'

        cursor.execute(query, (username, password))
        user_id= cursor.fetchone()
        
        connection.close()

        
        if user_id:
            session['logged_in'] = True
            session['username'] = username
            session['user_type'] = user_type
            # session['user_id'] = user_id[0]
            session['user_role'] = user_role
            return redirect('/')
        else:
            return render_template('login.html', message='Invalid username or password.')
    else:
        return render_template('login.html')

@app.route('/project')
def project():
    if 'logged_in' in session:
        return render_template('project.html')
    else:
        return redirect('/login')

@app.route('/search', methods=['GET'])
def search_flights():
    from_location = request.args.get('from')
    to_location = request.args.get('to')
    date = request.args.get('date')
    no_of_pass=(request.args.get('no_of_pass'))
    flight_class = request.args.get('class1')
    

    if no_of_pass:
        no_of_pass = int(no_of_pass)

    session['origin'] = from_location
    session['destination'] = to_location
    session['dep_date'] = date
    session['no_of_pass'] = no_of_pass
    session['flight_class'] = flight_class
    
    connection = connect_to_database()
    cursor = connection.cursor()

    user=session.get('flight_class')

    if user=='economy':
        query =  "SELECT f.flight_no, f.from_location, f.to_location,f.date, f.arrival_date,f.departure_time, f.arrival_time, f.price_economy FROM flight_detail f Join airline_details a ON f.Airline_id=a.Airline_id WHERE f.from_location=%s AND f.to_location=%s AND f.date=%s and a.active='Yes'"
        
    else:
        query =  "SELECT f.flight_no, f.from_location, f.to_location,f.date, f.arrival_date,f.departure_time, f.arrival_time, f.price_business FROM flight_detail f Join airline_details a ON f.Airline_id=a.Airline_id WHERE f.from_location=%s AND f.to_location=%s AND f.date=%s and a.active='Yes'"
    cursor.execute(query, (from_location, to_location, date))
    flights = cursor.fetchall()
    
    connection.close()


    return render_template('availableflights.html', flights=flights)



@app.route('/passenger', methods=['GET'])
def passenger_details():
    if 'username' not in session:
        return redirect('/login') 
    
    flight_id = request.args.get('flight_id')
    price = request.args.get('price')

    if price:
        price = int(price)

    session['flight_id'] = flight_id
    session['price'] = price

    if not flight_id:
        return redirect('/')  
    
    connection = connect_to_database()
    cursor = connection.cursor(dictionary=True)

    query = "SELECT * FROM flight_detail WHERE flight_no = %s"
    cursor.execute(query, (flight_id,))
    flight_details = cursor.fetchone()

    connection.close()

    if not flight_details:
        return redirect('/')  

    no_of_pass=session.get('no_of_pass')
    return render_template('passenger.html', flight_details=flight_details, no_of_pass=no_of_pass)

def generate_pnr():
    return ''.join(random.choices('0123456789', k=8))


@app.route('/submit', methods=['POST'])
def submit():
    if request.method == 'POST':
        Name = request.form.getlist('passenger_name[]')
        Age = request.form.getlist('passenger_age[]')
        Email = request.form.getlist('passenger_email[]')
        Gender = request.form.getlist('Gender')
        ID_type = request.form.getlist('ID')
        ID_no = request.form.getlist('passenger_id[]')
        meal_choice = request.form.getlist('inflight-meal')

        
        insurances = request.form.get('Insurance') 
        priority_checkins =request.form.get('Priority-checkin') 
        premium_lounges = request.form.get('Premium-lounge') 

        price=session['price']

        session['meal']=meal_choice

        flight_id = session.get('flight_id')
        class1 = session.get('flight_class')
        customer = session['username']
        date = session['dep_date']
        no_of_pass = session['no_of_pass']
        pnr1 = generate_pnr() 

        connection = connect_to_database()
        cursor = connection.cursor()

        query = "INSERT INTO ticket_details(pnr,date_of_reservation,flight_no,Journey_date,class,no_of_passengers,lounge_access,priority_checkin,insurance,customer_id) values(%s,NOW(),%s,%s,%s,%s,%s,%s,%s,%s)"
        values = (pnr1, flight_id, date, class1, no_of_pass, premium_lounges, priority_checkins, insurances, customer)
        cursor.execute(query, values)

        update_query = "UPDATE ticket_details SET booking_status = 'pending' WHERE flight_no = %s and pnr=%s"
        cursor.execute(update_query, (flight_id,pnr1))


        query = "SELECT pnr FROM ticket_details WHERE flight_no = %s AND customer_id = %s ORDER BY date_of_reservation DESC LIMIT 1"
        cursor.execute(query, (flight_id, session['username']))
        pnr = cursor.fetchone()

        session['pnr']=pnr1


        for i in range(len(Name)):
    
            query = "INSERT INTO passenger (passenger_id ,pnr,Name,Age, Email, Gender, ID_type, ID_no,meal_choice) VALUES (%s,%s, %s, %s, %s, %s, %s, %s, %s)"
            values = (i+1, pnr1, Name[i], Age[i], Email[i], Gender[i], ID_type[i], ID_no[i], meal_choice[i])
            cursor.execute(query, values)

        connection.commit()
        connection.close()

        return redirect(url_for('payment', price=price))

def generate_payment_id():
    return ''.join(random.choices('0123456789', k=8))


@app.route('/payment')
def payment():
    price = session.get('price')  
    meal_choices = session.get('meal')  
    no_of_passengers = session.get('no_of_pass')  
    meal_charge_per_passenger = 600  
    payment_id = generate_payment_id()  

    total_meal_charges = sum(600 for choice in meal_choices if choice == 'yes')  

    payment_id = generate_payment_id()  

    session['payment_id']=payment_id

    return render_template('payment.html', price=price, total_meal_charges=total_meal_charges, no_of_passengers=no_of_passengers, payment_id=payment_id)


@app.route('/logout')
def logout():

    session.clear()
    return redirect(url_for('index'))

@app.route('/ticket_confirmation')
def ticket_confirmation():
    pnr_number = session.get('pnr')
    if not pnr_number:
        return redirect('/')  
    
    return render_template('ticket_confirmation.html',pnr_number=pnr_number)


@app.route('/create_account', methods=['GET', 'POST'])
def create_account():
    if request.method == 'POST':
        username = request.form['username']
        password = request.form['password']
        name = request.form['NAME']
        email = request.form['Email']
        age = request.form['Age']
        phone = request.form['Phone_No']

        db_connection = connect_to_database()
        cursor = db_connection.cursor()
        query = "INSERT INTO customers (username, password, NAME, Email, Age, Phone_No) VALUES (%s, %s, %s, %s, %s, %s)"
        cursor.execute(query, (username, password, name, email, age, phone))
        db_connection.commit()

        cursor.close()

        return render_template('login.html', message='Account Created Successfully!')  
    else:
        return render_template('create_account.html')


@app.route('/pay', methods=['GET', 'POST'])
def pay():
    if request.method == 'POST':
        payment_mode = request.form['payment_mode']
        pnr = session.get('pnr')
        total_charge = request.form['total_charge']  

    
        payment_id = session.get('payment_id')

        
        connection = connect_to_database()
        cursor = connection.cursor()

        query = "INSERT INTO payment_details (transaction_id, pnr, payment_date, payment_amount, payment_mode) VALUES (%s, %s, NOW(), %s, %s)"
        values = (payment_id, pnr, total_charge, payment_mode)
        cursor.execute(query, values)


        connection.commit()
        connection.close()

        return redirect('/ticket_confirmation')


def get_ticket_details(customer_id):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)


    query = "SELECT * FROM ticket_details WHERE customer_id = %s AND booking_status='CONFIRMED'"
    cursor.execute(query, (customer_id,))
    ticket_details = cursor.fetchall()

    for ticket in ticket_details:
        ticket['passengers'] = get_passenger_details(ticket['pnr'], cursor)
    


    cursor.close()
    connection.close()

    return ticket_details

def get_passenger_details(pnr, cursor):
    query = "SELECT * FROM passenger WHERE pnr = %s"
    cursor.execute(query, (pnr,))
    return cursor.fetchall()


@app.route('/t')
def ticket():
    customer = session['username'] 
    from_loc=session.get('origin')
    to=session.get('destination')
    class1 = session.get('flight_class')


    ticket_details = get_ticket_details(customer)

    

    return render_template('display_ticket.html', ticket_details=ticket_details,from_loc=from_loc,to=to,class1=class1)

@app.route('/pnrforcancel')
def pnr_cancell():
    if 'logged_in' in session:
        return render_template('cancel_ticket.html')
    else:
        return redirect('/login')

@app.route('/getpnr', methods=['POST'])
def search_pnr():
    pnr= request.form.get('pnr')

    from_loc=session.get('origin')
    to=session.get('destination')

    connection = connect_to_database()
    cursor = connection.cursor()

    query = "SELECT * FROM ticket_details WHERE pnr = %s "
    cursor.execute(query,(pnr,))
    pnr_detail = cursor.fetchall()

    if pnr_detail:
        booking_status=pnr_detail[5]

        if booking_status=='CONFIRMED':
            return render_template('cancel_ticket2.html',pnr_detail=pnr_detail,from_loc=from_loc,to=to)
        
        else:
            return render_template('cancel_ticket.html', message='Already cancelled .')
    else:
        return render_template('cancel_ticket2.html')


@app.route('/cancel_ticket2/<pnr>', methods=['GET', 'POST'])
def cancel_ticket(pnr):
    connection = mysql.connector.connect(**db_config)
    cursor = connection.cursor(dictionary=True)

    query="UPDATE ticket_details set booking_status='CANCELLED' where pnr=%s"
    cursor.execute(query,(pnr,))
    connection.commit()


    query = "SELECT 0.85 * p.payment_amount AS refund_amount FROM Ticket_Details t JOIN Payment_Details p ON t.pnr = p.pnr WHERE t.pnr = %s"
    cursor.execute(query, (pnr,))
    ticket_info = cursor.fetchone()

    refund_amount = ticket_info

    session['refund_amount']=refund_amount

    return redirect('/cancel_confirmation')
    
    
@app.route('/cancel_confirmation')
def cancel_conformation():
    
    refund_amount = session.get('refund_amount')

    return render_template('cancel_ticket_conformation.html', refund_amount=refund_amount)


# @app.route('/addflight', methods=['GET', 'POST'])
# def addflight():
    # if 'logged_in' in session:
    #     return render_template('Add_flight.html')
   
    # else:
    #     return redirect('/login')

    # if request.method == 'POST':
    #     username = request.form.get('username')
    #     password = request.form.get('password')
    #     name = request.form.get('NAME')
    #     email = request.form.get('Email')
    #     age = request.form.get('Age')
    #     phone = request.form.get('Phone_No')

    #     db_connection = connect_to_database()
    #     cursor = db_connection.cursor()
    #     query = "INSERT INTO customers (username, password, NAME, Email, Age, Phone_No) VALUES (%s, %s, %s, %s, %s, %s)"
    #     cursor.execute(query, (username, password, name, email, age, phone,))
    #     db_connection.commit()

    #     cursor.close()

    #     return render_template('login.html', message='Account Created Successfully!')  
    # else:
    #     return render_template('login.html')
    
@app.route('/A_viewticket', methods=['GET', 'POST'])
def A_viewticket():  # Corrected function name
    if request.method == 'POST':
        Airline = request.form['Airline']
        From = request.form['From']
        To = request.form.get('To')
        Date = request.form['DATE']

        db_connection = connect_to_database()
        cursor = db_connection.cursor()

        if Airline and From and To and Date:

            query=" SELECT f.flight_no from flight_detail f  where f.from_location=%s and f.to_location=%s and f.date=%s and f.Airline_id=%s"
            cursor.execute(query,(From,To,Date,Airline,))
            ticket=cursor.fetchone()

            query="SELECT Airline_type from airline_details where Airline_id=%s"
            cursor.execute(query,(Airline,))
            Airline_t=cursor.fetchone()


            Airline_type=Airline_t[0]

            if ticket:
                ticket_no=ticket[0]
                # Airline_type=ticket[0][1]
                

                query_passenger = "select p.* , t.class,t.booking_status from passenger p JOIN ticket_details t on p.pnr = t.pnr WHERE t.flight_no=%s"
                cursor.execute(query_passenger, (ticket_no,))
                passenger_info = cursor.fetchall()


                return render_template('adminviewticket2.html',passenger_info=passenger_info,Date=Date,From=From,To=To,Airline_type=Airline_type)
            else:
                return render_template('adminviewticket.html', message="No Airline Available")
        
        elif Airline:
            query=" SELECT f.flight_no from flight_detail f where f.Airline_id=%s"
            cursor.execute(query,(Airline,))
            ticket=cursor.fetchall()

            passenger_info=[]

            print(ticket)

            for i in range(len(ticket)):
                query_passenger = "select p.* , t.class,t.booking_status from passenger p JOIN ticket_details t on p.pnr = t.pnr WHERE t.flight_no=%s"
                cursor.execute(query_passenger, (ticket[i]))
                passenger1 = cursor.fetchall()

                passenger_info.extend(passenger1)
            
            return render_template('adminviewticket2.html',passenger_info=passenger_info)


    else:
        return render_template('adminviewticket.html')


@app.route('/schedule', methods=['POST', 'GET'])
def schedule():
    if request.method =='POST':
        From=request.form['From']
        To=request.form.get('To')
        Date=request.form.get('DATE')

        db_connection = connect_to_database()
        cursor = db_connection.cursor()
        if Date:
            query="Select * from flight_detail where from_location=%s and to_location=%s and date=%s"
            cursor.execute(query,(From,To,Date))
            flight_detail=cursor.fetchall()
        else:
            query="Select * from flight_detail where from_location=%s and to_location=%s"
            cursor.execute(query,(From,To))
            flight_detail=cursor.fetchall()

        db_connection = connect_to_database()
        cursor = db_connection.cursor()

        return render_template('checkschedule.html', flight_detail=flight_detail)

    else :
        db_connection = connect_to_database()
        cursor = db_connection.cursor()

        query = "SELECT * FROM flight_detail"
        cursor.execute(query)
        flight_detail = cursor.fetchall()

        cursor.close()
        db_connection.close()

        return render_template('checkschedule.html', flight_detail=flight_detail)
    
# @app.route('/A_addfligth',method=['GET','POST'])
# def A_addflight():
#     if request.method=='POST':
#         return redirect('/A_addflight')

#     return render_template('Add_flight.html')    


@app.route('/Aaddflight', methods=['POST','GET'])
def A_addflight():
    if request.method == 'POST':
        flight_no=request.form.get('flight_no')
        from_location=request.form.get('FROM')
        to_location=request.form.get('TO')
        date=request.form.get('DATE')
        arrival_date=request.form.get('Arrival_date')
        departure_time=request.form.get('TIME')
        arrival_time=request.form.get('Arrival_time')
        price_economy=request.form.get('price_E')
        price_business=request.form.get('price_B')
        Airline_id=request.form.get('Airline_ID')

        db_connection = connect_to_database()
        cursor = db_connection.cursor()

        query="INSERT INTO flight_detail VALUES (%s,%s,%s,%s,%s,%s,%s,%s,%s,%s)"
        values=(flight_no,from_location,to_location,date,arrival_date,departure_time,arrival_time,price_economy,price_business,Airline_id)
        cursor.execute(query,values)

        db_connection.commit()  # Corrected method to commit changes

        cursor.close()
        db_connection.close()

        return redirect('/schedule')
    
    else:
        return render_template('Add_flight.html')
    
@app.route('/update_flight',methods=['POST','GET'])
def update_flight():
    if request.method=='POST':
        flight_no = request.form.get('flight_no')
        from_location = request.form.get('FROM')
        to_location = request.form.get('TO')
        date = request.form.get('DATE')
        arrival_date = request.form.get('Arrival_date')
        departure_time = request.form.get('TIME')
        arrival_time = request.form.get('Arrival_time')
        price_economy = request.form.get('price_E')
        price_business = request.form.get('price_B')
        # We don't need to update Airline_id and flight_no, so we don't retrieve them from the form

        db_connection = connect_to_database()
        cursor = db_connection.cursor()

        query = "UPDATE flight_detail SET from_location=%s, to_location=%s, date=%s, arrival_date=%s, departure_time=%s, arrival_time=%s, price_economy=%s, price_business=%s WHERE flight_no=%s"
        values = (from_location, to_location, date, arrival_date, departure_time, arrival_time, price_economy, price_business, flight_no)
        cursor.execute(query, values)

        db_connection.commit()

        cursor.close()
        db_connection.close()

        return redirect('/schedule')

    else:
        flight_no = request.args.get('flight_no')
        from_location = request.args.get('from_location')
        to_location = request.args.get('to_location')
        date = request.args.get('date')
        arrival_date = request.args.get('arrival_date')
        departure_time = request.args.get('departure_time')
        arrival_time = request.args.get('arrival_time')
        price_economy = request.args.get('price_economy')
        price_business = request.args.get('price_business')
        Airline_id = request.args.get('Airline_id')

        # Render the edit_flight.html template and pass the flight details
        return render_template('update_flight.html', flight_no=flight_no, from_location=from_location, to_location=to_location, date=date, arrival_date=arrival_date, departure_time=departure_time, arrival_time=arrival_time, price_economy=price_economy, price_business=price_business, Airline_id=Airline_id)

@app.route('/AaddAirline' ,methods=['GET','POST'])
def A_addAirline():
    if request.method=='POST':
        Airline_ID=request.form['Airline_ID']
        type=request.form['type']
        total_capacity=request.form['total_capacity']
        Active=request.form['Active']

        print(Airline_ID)
        print(type)
        print(total_capacity)

        db_connection = connect_to_database()
        cursor = db_connection.cursor()

        query="INSERT INTO Airline_details (Airline_id,Airline_type,total_Capacity,active) VALUES (%s,%s,%s,%s)"
        cursor.execute(query,(Airline_ID,type,total_capacity,Active,))

        db_connection.commit()
        cursor.close()
        db_connection.close()

        return redirect('/showairline')

    else:
        return render_template('Add_airline.html')

@app.route('/showairline')
def show_Airline():
    db_connection = connect_to_database()
    cursor = db_connection.cursor()

    query="SELECT * from Airline_details"
    cursor.execute(query)
    Airline_info = cursor.fetchall()

    cursor.close()
    db_connection.close()

    return render_template("Show_Airline.html",Airline_info=Airline_info)

@app.route('/Activate/<string:Airline_id>')
def Activate(Airline_id):
    
    db_connection = connect_to_database()
    cursor = db_connection.cursor()

    query="UPDATE Airline_details SET active ='No' where airline_id=%s"
    cursor.execute(query,(Airline_id,))

    db_connection.commit()

    cursor.close()
    db_connection.close()

    return redirect('/showairline')

@app.route('/DE_Activate/<string:Airline_id>')
def DE_Activate(Airline_id):
    
    db_connection = connect_to_database()
    cursor = db_connection.cursor()

    query="UPDATE Airline_details SET active ='Yes' where airline_id=%s"
    cursor.execute(query,(Airline_id,))

    db_connection.commit()

    cursor.close()
    db_connection.close()

    return redirect('/showairline')


if __name__ == '__main__':
    app.run(debug=True)
