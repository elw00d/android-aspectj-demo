package su.elwood.diagnostics;

import android.util.Log;

import java.util.Map;
import java.util.HashMap;

/**
 * The Trace aspect injects tracing messages before and after allmethod except
 * ones annotated with @DontTraceThis.
 */

aspect Trace {

	pointcut methodCalls():
	  execution(!@su.elwood.diagnostics.DontTraceThis * su.elwood..*(..))&& !within(su.elwood.diagnostics.Trace) && !within(@su.elwood.diagnostics.DontTraceThis *);

    /**
     * Allows to measure and display time elapsed for methods execution
     */
    private static final boolean TRACE_RETURNS = false;

	Object around() : methodCalls() {
		String threadName = Thread.currentThread().getName();
		if ( null == threadMap.get(threadName) ) threadMap.put(threadName, 0);
		int stackDepth = threadMap.get(threadName) + 1;
		threadMap.put(threadName,stackDepth);

        // todo : mb cache this in thread-local
		String name = Thread.currentThread().getName();

        // todo : optimize this if need (cache indents from 1 to 10 in static fields)
		StringBuilder indentSb = new StringBuilder();
		for (int index = 0; index < stackDepth; index++)
			indentSb .append(">");
        String indent = indentSb.toString();

        // todo : implement logging to special file instead of using android logging api
        Log.i( "ASPECTJ_DEMO_" , name + ": " + indent + " "
                + thisJoinPointStaticPart.getSignature().toString() +
                String.format( " (%s:%d)", thisJoinPointStaticPart.getSourceLocation().getFileName(),
                        thisJoinPointStaticPart.getSourceLocation().getLine() ) );

        if (TRACE_RETURNS) {
            // todo : improve measure using StopWatch class (that uses nanotime)
            long start = System.currentTimeMillis();
            try {
                return proceed();
            } finally {
                long end = System.currentTimeMillis();
                Log.i( "ASPECTJ_DEMO_" , name + ": " + indent.replace('>','<') + " "
                        + thisJoinPointStaticPart.getSignature().toString() + "("
                        + (end - start) + " ms)");
                threadMap.put(threadName,stackDepth - 1);
            }
        } else {
            try {
                return proceed();
            } finally {
                threadMap.put(threadName,stackDepth - 1);
            }
        }
	}

    // todo : check if this map is thread safe for our case
    // todo : mb thread local variables will be more efficient here
	private static Map<String, Integer> threadMap = new HashMap<String,Integer>();
}

