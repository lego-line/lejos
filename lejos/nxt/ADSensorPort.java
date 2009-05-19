package lejos.nxt;

/**
 * An abstraction for a port that supports Analog/Digital sensors.
 * 
 * @author Lawrie Griffiths.
 * 
 * <br/><br/>WARNING: THIS CLASS IS SHARED BETWEEN THE classes AND pccomms PROJECTS.
 * DO NOT EDIT THE VERSION IN pccomms AS IT WILL BE OVERWRITTEN WHEN THE PROJECT IS BUILT.
 */
public interface ADSensorPort extends BasicSensorPort {

	public boolean readBooleanValue();
	
	public int readRawValue();
	
	public int readValue();
}
