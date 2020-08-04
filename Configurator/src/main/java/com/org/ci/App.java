package com.org.ci;

public class App 
{
	public static void main( String[] args ) throws ReplacementEngineException
	{
		String output;
		String template;
		
		if(args.length==2)
		{
			output = args[0];
			template = args[1];
		}
		else 
		{
			output = "Configurator/output";
			template = "template";
		}

        ReplacementEngine importer = new ReplacementEngine(output, template);
        importer.load();
	}
}
