public abstract class Document {
    public abstract void open();
}

// Word Document
class WordDocument extends Document {
    public void open() {
        System.out.println("Opening a Word document.");
    }
}

// PDF Document
class PdfDocument extends Document {
    public void open() {
        System.out.println("Opening a PDF document.");
    }
}

// Excel Document
class ExcelDocument extends Document {
    public void open() {
        System.out.println("Opening an Excel document.");
    }
}
