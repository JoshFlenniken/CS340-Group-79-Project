# Citation for the following functions:
# Date: 5/21/2025
# Adapted from:
# Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-implementing-cud-operations-in-your-app?module_item_id=25352968
# Source URL: https://canvas.oregonstate.edu/courses/1999601/pages/exploration-web-application-technology-2?module_item_id=25352948

from flask import Flask, render_template, request, redirect
import database.db_connector as db

PORT = 10985

app = Flask(__name__)

# ########################################
# ########## ROUTE HANDLERS

# READ ROUTES
@app.route("/", methods=["GET"])
def home():
    try:
        return render_template("home.j2")

    except Exception as e:
        print(f"Error rendering page: {e}")
        return "An error occurred while rendering the page.", 500


@app.route("/customers", methods=["GET"])
def customers():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Create and execute queries
        
        query1 = "SELECT * FROM Customers;"
        customers = db.query(dbConnection, query1).fetchall()

        # Render the customers.j2 file
        return render_template(
            "customers.j2", customers=customers
        )

    except Exception as e:
        print(f"Error executing queries: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/employees", methods=["GET"])
def employees():
    try:
        dbConnection = db.connectDB()  # Open database connection

        # Create and execute queries
        query1 = "SELECT * FROM Employees;"
        employees = db.query(dbConnection, query1).fetchall()

        # Render the employees.j2 file
        return render_template(
            "employees.j2", employees=employees
        )

    except Exception as e:
        print(f"Error executing queries: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/orders", methods=["GET"])
def orders():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # Create and execute queries
        # In query2, JOIN clause displays the customer names
        #       instead of just ID values
        query1 = "SELECT * FROM Orders;"
        query2 = "SELECT Orders.orderID, Customers.firstName AS 'First', Customers.lastName AS 'Last', Orders.employeeID, Orders.orderDate \
            FROM Customers \
            JOIN Orders ON Orders.customerID = Customers.customerID;"
        query3 = "SELECT Employees.employeeID, Employees.firstName, Employees.lastName \
            FROM Employees \
            JOIN Orders ON Orders.employeeID = Employees.employeeID;"
        orders = db.query(dbConnection, query2).fetchall()
        customers = db.query(dbConnection, query1).fetchall()
        employees = db.query(dbConnection, query3).fetchall()

        # Render the orders.j2 file
        return render_template(
            "orders.j2", orders=orders, customers=customers, employees=employees
        )

    except Exception as e:
        print(f"Error executing queries: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/products", methods=["GET"])
def products():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        query1 = "SELECT * FROM Products;"
        products = db.query(dbConnection, query1).fetchall()

        # Render the products.j2 file
        return render_template(
            "products.j2", products=products
        )

    except Exception as e:
        print(f"Error executing queries: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

@app.route("/orderdetails", methods=["GET"])
def orderdetails():
    try:
        dbConnection = db.connectDB()  # Open our database connection

        # JOIN clause creates intersections between Orders and Products tables.
        query1 = "SELECT * FROM OrderDetails;"
        query2 = "SELECT Products.productID, Products.productName \
            FROM Products \
            LEFT JOIN OrderDetails ON OrderDetails.productID = Products.productID;"
        query3 = "SELECT Orders.orderID FROM Orders;"
        orderdetails = db.query(dbConnection, query1).fetchall()
        products = db.query(dbConnection, query2).fetchall()
        orders = db.query(dbConnection, query3).fetchall()

        # Render the orderdetails.j2 file
        return render_template(
            "orderdetails.j2", orderdetails=orderdetails, products=products, orders=orders
        )

    except Exception as e:
        print(f"Error executing queries: {e}")
        return "An error occurred while executing the database queries.", 500

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()


# RESET ROUTES
@app.route("/home/reset", methods=["POST"])
def reset_database():
    try:
        dbConnection = db.connectDB()  # Open our database connection
        cursor = dbConnection.cursor()

        # Create and execute our queries
        # Using parameterized queries (Prevents SQL injection attacks)
        query1 = "CALL sp_ResetDatabase();"
        cursor.execute(query1, ())

        # Consume the result set (if any) before running the next query
        cursor.nextset()  # Move to the next result set (for CALL statements)

        dbConnection.commit()  # commit the transaction

        print(f"Resetting database data")

        # Redirect the user to the updated webpage
        return redirect("/")

    except Exception as e:
        print(f"Error executing queries: {e}")
        return (
            "An error occurred while executing the database queries.",
            500,
        )

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

# DELETE ROUTES
@app.route("/customers/delete", methods=["POST"])
def delete_customers():
    try:
        dbConnection = db.connectDB()  # Open our database connection
        cursor = dbConnection.cursor()

        # Get form data
        customer_id = request.form["delete_customer_id"]
        customer_name = request.form["delete_customer_name"]

        # Create and execute our queries
        # Using parameterized queries (Prevents SQL injection attacks)
        query1 = "CALL sp_DeleteCustomer(%s);"
        cursor.execute(query1, (customer_id))

        dbConnection.commit()  # commit the transaction

        print(f"DELETE bsg-people. ID: {customer_id} Name: {customer_name}")

        # Redirect the user to the updated webpage
        return redirect("/customers")

    except Exception as e:
        print(f"Error executing queries: {e}")
        return (
            "An error occurred while executing the database queries.",
            500,
        )

    finally:
        # Close the DB connection, if it exists
        if "dbConnection" in locals() and dbConnection:
            dbConnection.close()

# ########################################
# ########## LISTENER

if __name__ == "__main__":
    app.run(
        port=PORT, debug=True
    )  # debug is an optional parameter. Behaves like nodemon in Node.
