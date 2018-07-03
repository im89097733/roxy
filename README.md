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
- /tools contains a little java.jar utility called jsonX used to easily integrate bash to json payloads from aws cli responses.  It gets used extensively in the bash scripts
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
Prerequisites
----------------
- Requires AWS CLI installed with appropriate access keys installed.
- Requires JRE
- bash (git bash)

Bootstrap
----------
1) from /TriNimbus/, optionally modify the values in setenv.sh as desired for your target architecture
3) run '. ./setenv.sh' from command line to setup env variables
4) follow instructions for 'Application' or 'Infrastructure'

Application
------------
To make changes to the application and deploy to existing infrastructure, follow these steps.

1) Create an instance from the AMI ${ROXY_BASE_AMI} with 'newInstance.sh'
2) update the .class files or HTML as desired (using MSTSC for Windows Container)
3) test that the code works (using local chrome browser localhost:8080/RESTTest.html
4) create a new AMI from this instance with 'newAMI.sh'
5) modify the LC for the ASGs to refer to the new AMI with 'updateLC.sh'
6) kill existing instances to force update as desired

Infrastructure
--------------
To create a new infrastructure space either for staging or prod, follow these steps:.

1) from /TriNimbus/deploy/infra/ run './createAll.sh' to build a complete infrastructure

To tear down the entire infrastructure:

1) from /TriNimbus/deploy/infra/ run './deleteAll.sh' to clean AWS of the last infrastructure

KNOWN ISSUES
=============
1) The endpoint target is trinimbus.andress.ca/RESTTest.html and it works on HTTP.
The account provided in the sandbox does not seem to have permissions to create a CERT on the ELB.
So the app does not currently work on HTTPS

2) there is some resource sprawl as I have been testing the scripts and since the kill script does not yet comprehensively cleanup the VPC trail