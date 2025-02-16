import pdfplumber

class PdfReader:
    def __init__(self, pdf_file, pages_array=None):
        self.pdf_file = pdf_file
        self.text = []
        self.pages_array = pages_array

    def pdfplumber(self):
        with pdfplumber.open(self.pdf_file) as pdf:
            # ページ数を取得
            total_pages = len(pdf.pages)
            # ページ数がself.pages_arrayで引数で複数指定されている場合、その対象のページのみ処理
            if self.pages_array is not None:
                for page_num in self.pages_array:
                    print(page_num)
                    if page_num <= total_pages:
                        page = pdf.pages[page_num - 1]
                        text = page.extract_text()
                        split_text = text.split('\n')
                        self.text.extend(split_text)
                    else:
                        print(f"Page {page_num} is out of range. Skipping...")


            # # PDFの各ページを処理
            # for page in pdf.pages:
            #     # ページからテキストを抽出
            #     text = page.extract_text()
            #     # 改行コードでsplitしてリストに追加
            #     split_text = text.split('\n')
            #     self.text.extend(split_text)
        return self.text
