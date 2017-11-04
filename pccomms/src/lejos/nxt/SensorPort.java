package lejos.nxt;

import lejos.pc.comm.*;
import lejos.nxt.remote.*;

/**
 * Port class. Contains 4 Port instances.<br>
 * Usage: Port.S4.readValue();
 * 
 * This version of the SensorPort class supports remote execution.
 * 
 * @author <a href="mailto:bbagnall@mts.net">Brian Bagnall</a>
 *
 */
public class SensorPort   {	
	private static final NXTCommand nxtCommand = NXTCommandConnector.getSingletonOpen();
		
	public static RemoteSensorPort S1 = new RemoteSensorPort(nxtCommand, 0);
	public static RemoteSensorPort S2 = new RemoteSensorPort(nxtCommand, 1);
	public static RemoteSensorPort S3 = new RemoteSensorPort(nxtCommand, 2);
	public static RemoteSensorPort S4 = new RemoteSensorPort(nxtCommand, 3);
	
	private static RemoteSensorPort[] ports = {S1,S2,S3,S4};
	
	public static RemoteSensorPort getInstance(int port) {
		return ports[port];
	}
}
