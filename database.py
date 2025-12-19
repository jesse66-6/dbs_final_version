import mysql.connector
from mysql.connector import Error

# Database connection configuration
# Update 'user' and 'password' to match your local MySQL setup
db_config = {
    'host': 'localhost',
    'database': 'EnterpriseInsuranceDB',
    'user': 'root',      
    'password': '123456' # <--- UPDATE THIS PASSWORD
}

def get_db_connection():
    """Establishes and returns a database connection."""
    try:
        connection = mysql.connector.connect(**db_config)
        if connection.is_connected():
            return connection
    except Error as e:
        print(f"❌ Error connecting to MySQL: {e}")
        return None