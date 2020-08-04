package com.org.ci;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileWriter;
import java.io.IOException;
import java.io.InputStream;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Map;
import java.util.Properties;
import java.util.Scanner;
import java.util.logging.Level;
import java.util.logging.Logger;

public class ReplacementEngine {

	private final Map<String, Map<String,String>> environments;
	private final String output;
	private final String template;
	private static final Logger LOGGER = Logger.getLogger("ReplacementEngine");
	
	public ReplacementEngine (String output, String template) throws ReplacementEngineException{
		this.output=output;
		this.template=template;
		this.environments = new HashMap<>();
		loadConfig();
	}
	
	/**
	* Populates environments from configuration
	*/
	private void loadConfig() throws ReplacementEngineException {

		Properties prop = new Properties();
		String filename = "config.properties";
		
		try(InputStream input = App.class.getClassLoader().getResourceAsStream(filename))
		{
			if(input==null)
			{
				throw new ReplacementEngineException("Sorry, unable to find " + filename);
			}

			//load map
			prop.load(input);

			Enumeration<?> e = prop.propertyNames();
			while (e.hasMoreElements()) 
			{
				String key = (String) e.nextElement();

				String[] cell = key.split("\\.");

				HashMap<String, String> dictionary;
				if(!environments.containsKey(cell[0]))
				{
					dictionary=new HashMap<>();
					environments.put(cell[0], dictionary);
				}
				else
				{
					dictionary = (HashMap<String, String>)environments.get(cell[0]);
				}
				dictionary.put(cell[1], prop.getProperty(key));
			}
		}
		catch (IOException e) 
		{
			throw new ReplacementEngineException(e.getMessage(), e);
		}
	}

	/**
	* generates configuration files for each environment and 
	* Initializes the dictionary and template and utilizing other functions, 
	* Utilizes the delete, workfolder and replace methods to 
	* manufacture files from a combination of template and a dictionary
	*/
	public void load() throws ReplacementEngineException{

		try
		{
			//iterate through template folder
			File inputFolder = new File(this.template);
			File outputFolder = new File(this.output);

			delete(outputFolder);
			outputFolder.mkdir();

			for (File templatefolder : inputFolder.listFiles())
			{
				if (!templatefolder.isDirectory()) 
				{
					continue;
				}
				
				File suboutputFolder = new File(outputFolder,templatefolder.getName());
				for (String environment : environments.keySet())
				{
					File outputenv = new File(suboutputFolder,environment);
					String workingpath = String.format("%s\\%s", templatefolder.getName(), environment);
					LOGGER.log(Level.INFO, workingpath);
					workfolder(templatefolder, outputenv, environment);
				}
			}
		}
		catch (IOException e) 
		{
			throw new ReplacementEngineException(e.getMessage(), e);
		}
	}

	/**
	* Iterates through files and folders, replacing the files as it is iterates.
	* @param  basefolder  root folder path
	* @param  outputfolder the location of output
	* @param  environment the environment for which the file is being generated
	*/
	private void workfolder(File basefolder, File outputFolder, String environment) throws IOException
	{
		if (!outputFolder.exists()) 
		{
			outputFolder.mkdirs();
		}

		for (File file : basefolder.listFiles()) 
		{
			if (file.isDirectory()) 
			{
				workfolder(file, new File(outputFolder, file.getName()), environment);
			}
			else 
			{
				replace(file, new File(outputFolder,file.getName()), environment);
			}
		}
	}

	/**
	* Method that replaces placeholder's with the corresponding key value
	* @param  source  source file
	* @param  output output file
	* @param  environment the environment for which the file is being generated
	*/
	private void replace(File source, File output, String env) throws IOException
	{
		if (!output.exists()) 
		{
			Boolean created = output.createNewFile();
			if(!created){
				throw new IOException("Unable to create file!");
			}
		}
		
		try (
			Scanner s=new Scanner(source).useDelimiter("(?<=\n)|(?!\n)(?<=\r)");
			FileWriter out=new FileWriter(output);
		)
		{		
			Map<String, String> environment = environments.get(env);
			String lineDest;
	
			while(s.hasNext()){
				String line=s.next();
				lineDest = line;
				if (lineDest.contains("${"))
				{
					for(Map.Entry<String, String> placeholder : environment.entrySet()){
						lineDest = lineDest.replace("${"+placeholder.getKey()+"}", placeholder.getValue());
						if(!lineDest.contains("${")){
							break;
						}
					}
				}
				out.write(lineDest);
			}
		
		}
	}

	/**
	* Checks and Deletes existing folders and directories
	* @param f takes file as the parameter and deletes it
	*/
	private void delete(File f) throws IOException {
		if(!f.exists()){
			 return;
		}
		if (f.isDirectory()) {
			for (File c : f.listFiles()){
				delete(c);
			}
		}
		if (!f.delete()){
			throw new FileNotFoundException("Failed to delete file: " + f);
		}
	}
}