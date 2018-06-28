# trinimbus

CONTENTS
==========
- OVERVIEW
- ARCHITECTURE
    - Nomenclature
    - RDS
    - Container(s) and Application
    - Network and Security
- DEVELOPMENT
- DEPLOYMENT
    - Application
    - Infrastructure
- KNOWN ISSUES

OVERVIEW
===========
This is a repo that contains code and scripts and docs for a demo for TriNimbus

- /arch contains a diagram that shows roughly what has been deployed manually (via console) to represent the target architecture
- /src contains java code:
    - Query.java is a servlet that provides the web interface (JSON payload to /query)
    - DBAccess.java provides RDS access for the servlet.
- /deploy contains AWS CLI deploy scripts
- worklog.txt is a diary of work that was done to get this pulled together


ARCHITECTURE
=============
Nomenclature
-------------
the resources for this assignment are prefixed with 'roxy' to distinguish them from other resources in the sandbox

RDS
----
RDS is running MySQL compatible Aurora DB.  This was deployed to a single zone in east1c.

Container(s) and Application
------------------
There is a two-tiered container:
1) an AMI is available (roxyTriNimbusDemo2:ami-0115477e) in the sandbox.  This AMI is a Windows Server configured to run a Tomcat Container Service (hosting Java servlets)
2) a Tomcat Server that is portable across OSs making it very easy to port to a Linux platform.  This Tomcat server auto-starts and auto-deploys the Query servlet.  This server also makes available /RESTTest.html which is generically capable of making POSTs to endpoints (servlet/urls) with JSON payload. See "running the app" below.

Network and Security
-----------------------
There is deployed a single ELB pointing to a single Target Group.  The Target Group is populated by 2 Auto-Scalers configured to maintain an instance count of 1 in their respective availability zone. The Launch Configuration(LC) (I could not get Templates to work due to permissions) is set to apply a security group to the instances that grant them network level access to the RDS.  The instances, via the LC are not accessible from the internet and therefore will only respond to requests from the ELB.  Everything form the ELB to the RDS is on the same VPC.

DEVELOPMENT
===========
Intentionally light on development instructions.  In order to modify and build the java code in /src requires a JDK and Tomcat SDK.  On the container all of the dependencies for the code exist in binary (.class) format.  The dependencies are light: Tomcat, JDBC driver for MySQL, com.gcs.JSON (libraries similar to aws or other flavours of JSON java libraries).  On the web side, there is a raw HTML file called RESTTest.html and it's Javascript dependencies are hosted in the ./scripts directory of the webcontent.

DEPLOYMENT
===============================
Application
------------
1) Create an instance from the AMI with the same SG (sg-5098021b (roxyEC2SG)),
2) update the .class files or HTML as desired
3) test that the code works
4) create a new AMI from this instance
5) modify the LC for the ASGs to refer to the new AMI
6) kill existing instances to force update as desired

Infrastructure
--------------
1) run VPC create
2) run RDS build and deploy to VPC
3) run TG build and deploy to VPC
4) run ASG/LC build and deploy to VPC and bind to TG
5) run ELB build and deploy to VPC and bind to TG
6) DNS mods and apply certs to ELB


KNOWN ISSUES
=============
The endpoint target is trinimbus.andress.ca/RESTTest.html and it works on HTTP
The account provided in the sandbox does not seem to have permissions to create a CERT on the ELB.
So the app does not currently work on HTTPS