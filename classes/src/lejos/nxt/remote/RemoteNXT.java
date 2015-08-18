package lejos.nxt.remote;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.util.ArrayList;

import lejos.nxt.comm.NXTCommConnector;
import lejos.nxt.comm.NXTConnection;

/**
 * Provides an API similar to the leJOS API for accessing
 * motors, sensors etc. on a remote NXT accessed over
 * Bluetooth using LCP.
 *
 */
public class RemoteNXT extends RemoteNXTBase {
	private static NXTComm getComm(String name, NXTCommConnector connector) throws IOException {
		NXTComm nxtComm = new NXTComm(connector);
		boolean open = nxtComm.open(name, NXTConnection.LCP);
		if (!open) throw new IOException("Failed to connect to " + name);
		return nxtComm;
	}
	
	public RemoteNXT(String name, NXTCommConnector connector) throws IOException {
		super(getComm(name, connector));
	}
}

