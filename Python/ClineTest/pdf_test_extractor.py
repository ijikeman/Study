from PyPDF2 import PdfReader

def extract_text_from_pdf(pdf_path):
    """
    Extracts text from a PDF file.

    Args:
        pdf_path (str): The path to the PDF file.

    Returns:
        str: The extracted text from the PDF, or an error message if extraction fails.
    """
    try:
        reader = PdfReader(pdf_path)
        text = ""
        for page in reader.pages:
            text += page.extract_text()
        return text
    except Exception as e:
        return f"Error: Could not extract text from PDF. {e}"

if __name__ == "__main__":
    pdf_file_path = "sample.pdf"  # Replace with your PDF file path
    extracted_text = extract_text_from_pdf(pdf_file_path)
    if "Error" in extracted_text:
        print(extracted_text) # Print error message
    else:
        print("Extracted Text:")
        print(extracted_text) # Print extracted text
