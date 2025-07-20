package com.example;

import org.junit.Test;
import static org.junit.Assert.*;

public class MainAppTest {
    @Test
    public void testAdd() {
        assertEquals(5, MainApp.add(2, 3));
    }
}
