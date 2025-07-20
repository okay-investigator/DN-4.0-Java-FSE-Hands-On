package com.example;

import org.junit.Test;
import static org.junit.Assert.assertEquals;

public class MainAppTest {

    @Test
    public void testMultiply() {
        MainApp app = new MainApp();
        int result = app.multiply(3, 4);
        assertEquals(12, result);
    }
}
