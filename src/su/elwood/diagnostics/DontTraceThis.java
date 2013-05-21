package su.elwood.diagnostics;

/**
 * @author igor.kostromin
 *         21.05.13 11:06
 *
 * Points AspectJ to ignore annotated method (or all methods of annotated class)
 * from weaving code and injecting trace calls.
 */
public @interface DontTraceThis {
}
