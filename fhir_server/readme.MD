To build the container run `docker build -t wedidntstartfhir .`
to then launch the container run `docker run --rm -d -p 8080:8080 --name=wedidntstartfhir wedidntstartfhir`
After about 2 Mins, you can browse the server on your machine here:
http://127.0.0.1:8080/
There is a base patient in the system as well (any other "initial data" we will want to add to the container)
http://127.0.0.1:8080/baseDstu3/Patient/1

Other helpful commands:
Startup a the container from the shell (you'll then need to run /root/addpatient.sh manually but the container will not exit and will print out the FHIR server logs:
docker run --rm --entrypoint=/bin/sh -ti  -p 8080:8080 --name=wedidntstartfhir wedidntstartfhir

Connect a shell to a running container:
docker exec -ti wedidntstartfhir /bin/sh

NOTE: the "wedidntstartfhir" is just the value set from --name=wedidntstartfhir  you can use different names ore the containerID listed from docker ps.
I added the --rm to destroy the container so it always starts fresh, you don't have to do that, but for a team development it will be much easier if we just make the startup process always return a fresh instance with known state.

Other notes - you have to be on port 8080
Some Macs use port 8080 to listen for Office updates. I only know how to disable this on Mac OS; if you have a different system that uses this updater, then you may need to google to find out how to disable this updater.

Here are the instructions on disabling the updater on the Mac OS:

1. Open Finder and navigate to the following directory "<root>/Library/Application Support/Microsoft/MAU2.0/
2. In this folder you should see "Microsoft AutoUpdate", launch the application.
3. In the "Microsoft AutoUpdate" window, switch to "Manually Check" update.
4. Close the "Microsoft AutoUpdate" application and restart your computer.

If this fix didn't work for you, then there maybe something else using the port. To figure out what is using the port, you can use the following command in Terminal:
"sudo lsof -i tcp:8080"

## For Windows with Linux Containers

Run this command:

`run -d -p 8080:8080 -v <PATH_TO_fhir_server>:/scripts --name=my-fhir-server djohnson325/hapi-fhir-jpaserver:stu3`

Be sure to replace the <PATH_TO_fhir_server> with the full path to the `fhir_server` folder in this repository. Then run the following:

`curl -X POST -d @./example_patient.json http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"`
or
`C:\curl\curl.exe -X POST --data-binary "@./example_patient.json" http://127.0.0.1:8080/baseDstu3/Patient -H "Content-Type: application/json"`

When running that command, be sure to give the correct path to the `example_patient.json` file.