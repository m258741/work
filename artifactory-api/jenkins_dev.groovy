
 // This is a starting point to build Codeshuttle classes and methods.
 //
 // IMPORTANT: You should MAKE A COPY OF THIS JOB  to work on because this job will be overwritten
 // on a Jenkins pod restart!

 // Load the library - You can specify a specific branch like 'dev'
 @Library('codeshuttle@artifactory_api')

 // Build the config map skeleton.  See: https://github.com/maximus-codeshuttle/codeshuttle/blob/dev/docs/developers/config_namespace.md
 def config = generateConfig()

 // Mock required config map data structures to test your methods.
 config.pipeline.debug = [
   global: true, // Turn off debug Messages globally.
   Jenkins: true, // Turn on debug messages for the Jenkins Class.
   NewClass: [
     myNewMethod: true  // Turn on debug messages fot the NewClass.myNewMethod method.
   ],
   WorkflowScript: false // Turn off debug messages for THIS Class/Script.
 ]

 // Mock required stepConfig map data structures to test your methods.
 stepConfig = [
   name: 'myStep'
 ]

 // Import java/groovy libs.
 import com.maximus.cicd.pipeline.libraries.Utilities
 import com.maximus.cicd.pipeline.libraries.Jenkins
 import groovy.io.FileType

 // Instantiate Class objects
 Utilities utilities = new Utilities(this)

 // Use Class methods
 utilities.printDebugJSON(config, 'config: ', config, this.class.getSimpleName(), 'config')
 utilities.printDebugJSON(config, 'stepConfig: ', stepConfig, this.class.getSimpleName(), 'stepConfig')


 // Define your new class and methods
 class NewClass implements Serializable {

   def context
   Utilities utilities
   Jenkins jenkins

   NewClass(context) {
     this.context = context
     this.utilities = new Utilities(context)
     this.jenkins = new Jenkins(context)
   }
   
   def createRepo(Map config) throws Exception {
    
        //dataUrl = "http://google.com"
        
        String credentialsId = 'artifactory-username-password-scm-pipeline-artifactory-artifactory-mars-pcf-maximus-com'
        
        String createUrl = 'https://artifactory.mars.pcf-maximus.com/artifactory/api/repositories/tlowe-repo-2'
        
        //dataUrl = config.services.mongodb.global.restApi.url + '/' + collection
            
        //utilities.printDebug('repoExists', "dataUrl: ${dataUrl}")
        //return utilities.httpGet(dataUrl, credentialsId,[:])
		
		String limit = '?&pagesize=1'
		limit = ''
		String contentType = 'APPLICATION_JSON'
		String acceptType = contentType
		
		//"key": "'${REPO_NAME}'",
		/*
		String body = '''
		{
  "key": "tlowe-repo-2",
  "rclass": "local",
  "packageType": "generic",
  "description": "My new repository",
  "notes": "Created via Artifactory REST API"
}
'''
*/
        String body = '{ "key": "tlowe-repo-2", "rclass": "local", "packageType": "generic", "description": "My new repository", "notes": "Created via Artifactory REST API" }'
		
		
		context.withCredentials([context.usernamePassword(credentialsId: credentialsId, passwordVariable: 'ARTIFACTORY_PASSWORD', usernameVariable: 'ARTIFACTORY_USER')]) {
            
            String creds = "${context.ARTIFACTORY_USER}:${context.ARTIFACTORY_PASSWORD}"
            
            utilities.printMessage("creds: " + creds)
            
            utilities.printMessage("command: curl -k -X PUT -u ${context.ARTIFACTORY_USER}:${context.ARTIFACTORY_PASSWORD} -H \'Content-Type: application/json\' -d \'${body}\' ${createUrl}")
            
            def command = "curl -k -X PUT -u ${context.ARTIFACTORY_USER}:${context.ARTIFACTORY_PASSWORD} -H \'Content-Type: application/json\' -d \'${body}\' ${createUrl}"
            jenkins.scriptWrapper(script: command)
                
            //String base64creds = utilities.toBase64(creds)    
    
            /*
		    // check for existance of repo
		    def results = utilities.httpPut(createUrl, base64creds,[:],body,contentType,acceptType,'200:499')
            utilities.printDebug(config, "results.status: ${results.status}", this.class.getSimpleName(), utilities.getCurrentMethodName())
            if (results.status == 200 ) {
				utilities.printMessage("createRepo: got 200 - repo " + repoUrl + "created")
			} else {
				utilities.printMessage("createRepo: ERROR: status not 200")
			}
			*/
		}
    }
    
   	/**
     * repoExists routine
     * <p>
     * @param config global config data
     * @param collection mongo collection name
     * @param credentialsId
     * @return
     */
    def repoExists(Map config) throws Exception {
        String repoUrl = null
        //dataUrl = "http://google.com"
        repoUrl = 'https://artifactory.mars.pcf-maximus.com/artifactory/tlowe-repo-2/'
        
        String credentialsId = ''
        
        //dataUrl = config.services.mongodb.global.restApi.url + '/' + collection
            
        //utilities.printDebug('repoExists', "dataUrl: ${dataUrl}")
        //return utilities.httpGet(dataUrl, credentialsId,[:])
		
		String limit = '?&pagesize=1'
		limit = ''
		String acceptType = 'NOT_SET'

		// check for existance of repo
		def results = utilities.httpGet(repoUrl, credentialsId,[:],'','',acceptType,'200:499')
		utilities.printMessage("HTTP_STATUS: " + Integer.toString(results.status))
            utilities.printDebug(config, "results.status: ${results.status}", this.class.getSimpleName(), utilities.getCurrentMethodName())
            if (results.status == 200 ) {
				utilities.printMessage("repoExists: got 200")
			} else if (results.status == 404) {
				utilities.printMessage("repoExists: 404 - NOT FOUND - creating new repo...")
				createRepo(config)
				
			} else {
				utilities.printMessage("repoExists: ERROR: status not 200 or 404")
			}
    }

   // Define new custom methods that you need to test.
   void myNewMethod(stepConfig, config) {
     utilities.printDebug(config, "Debug message", this.class.getSimpleName(), utilities.getCurrentMethodName())
     utilities.printDebugJSON(config, 'config: ', config, this.class.getSimpleName(), utilities.getCurrentMethodName())
     utilities.printDebugJSON(config, 'stepConfig: ', stepConfig, this.class.getSimpleName(), utilities.getCurrentMethodName())
     utilities.printMessage("Hello " + stepConfig.name + ", from " + this.class.getSimpleName() + "." + utilities.getCurrentMethodName() + "(stepConfig, config)")
   }

   @NonCPS
   String fileCount (String folder) {
     def dir = new File(folder)
     Integer filecount = 0
     dir.eachFileRecurse (FileType.FILES) { file ->
       filecount += 1
     }

     return filecount
   }

   @NonCPS
   void folders(String folder) {
     File dir = new File(folder)
     dir.eachFile FileType.DIRECTORIES,  { subFolder ->
       context.println subFolder.path + ': ' + fileCount(subFolder.path)
     }
   }
 }

 runOnMaster = false

 if (runOnMaster) {
   node('master') {
     sh "env | sort ; ls -la '" + env.WORKSPACE + "'"
       // Instantiate your newClass from NewClass
       NewClass newClass = new NewClass(this)

       // Call your method[s]
       newClass.myNewMethod(stepConfig, config)

       newClass.folders(env.WORKSPACE)
   }
 } else {
   // Define a kubernetes pod to run in, if required.
   //
   // We build a pod Maven 3.6.3 JDK 8 with a single container as an example
   // Note: The pod can contain multiple containers if required.
   podTemplate(yaml: """---
   apiVersion: v1
   kind: Pod
   spec:
     containers:
       - name: csagent
         image: scm.artifactory.mars.pcf-maximus.com/codeshuttle/dev/codeshuttle-agent:latest
         imagePullPolicy: Always
         resources:
           limits:
             memory: 4Gi
             ephemeral-storage: 4Gi
             cpu: 2
           requests:
             memory: 2Gi
             ephemeral-storage: 1Gi
             cpu: .5
         securityContext:
           privileged: true
           runAsUser: 0
         tty: true
     nodeSelector:
       codeshuttle.type: linux-agent
     restartPolicy: Never""")

   // Start the pod.
   {
     node(POD_LABEL) {
       container('csagent') {
         sh "env | sort ; ls -la '" + env.WORKSPACE + "'"
         // Instantiate your newClass from NewClass
         NewClass newClass = new NewClass(this)

         // Call your method[s]
         newClass.myNewMethod(stepConfig, config)
         
         newClass.createRepo(config)

         // // The below fails if not run on Master
         // newClass.folders(env.WORKSPACE)
       }
     }
   }
 }
      