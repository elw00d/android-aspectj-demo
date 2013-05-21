package su.elwood;

import android.app.Activity;
import android.os.Bundle;

public class MainActivity extends Activity {
    /**
     * Called when the activity is first created.
     */
    @Override
    public void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.main);

        // several method calls for test
        foo();
        bar(1);
    }

    private void foo() {
        bar(0);
    }

    private void bar(int x) {
    }
}
