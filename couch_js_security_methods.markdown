# Security

## Security Intro

The default authentication db is called "_users". In this db the information about the users is stored. You can change the authentication db like this:

    users_db = new CouchDB("custom_users_db");
    users_db.createDb();

    CouchDB.request("PUT", "/_config/couch_httpd_auth/authentication_db", { body: JSON.stringify("custom_users_db")});

You can "signup" like this:

    userDoc = CouchDB.prepareUserDoc({name: "username", roles: ["customrole"]}, "secretpassword");

    users_db.save(userDoc);


## .login()

### CouchDB.login("username", "secretpassword")

### Description
Does a POST request to "_session" with the user details.

### Results
A created [session](/session) with the user name and roles.

### Returns
    {"ok": true, "name": "username", "roles": ["customrole"]}

### Prerequisites
A user doc [prepareUserDoc](/prepareUserDoc), saved in an [authentication db](/security-intro).


## .logout()

### CouchDB.logout()

### Description
Does a DELETE request to "_session".

### Results
The [session's](/session) user name is set to null and the custom role is removed from the roles array.

### Returns
    {"ok": true}

### Prerequisites
A user [session](/session), as created by [login](/login).


## .session()

### CouchDB.session(options)

### Description
Does a GET request to "_session". 

### Returns
    {"ok": true, "userCtx": {"name": "username", "roles": ["customrole"]}, "info": {"authentication_db": "_users", "authentication_handlers": ["oauth", "cookie", "default"], "authenticated": "cookie"}}

### Prerequisites
A user [session](/session), as created by [login](/login). When there is no session, userCtx.name is null.


## .prepareUserDoc()

### CouchDB.prepareUserDoc(userDoc, "secretpassword")

### Description
* Hashes the password 
* Adds an empty roles array to the userDoc when not specified
* Adds an _id, composed of user_prefix and name, to the userDoc when not specified

### Returns
    {"name": "username", "roles": ["customrole"], "_id": "org.couchdb.user:customrole", "salt":"a salt", "password_sha": "hashed password", "type":"user"}
    
### Example
    CouchDB.prepareUserDoc({name: "username", roles: ["customrole"]}, "secretpassword")
  

