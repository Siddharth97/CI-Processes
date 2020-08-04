package com.org.ci;

public class ReplacementEngineException extends Exception {
	private static final long serialVersionUID = -4980016949238498850L;

	public ReplacementEngineException() {
        super();
    }

    public ReplacementEngineException(String message) {
            super(message);
    }

    public ReplacementEngineException(String message, Throwable t){
        super(message, t);
    }
}