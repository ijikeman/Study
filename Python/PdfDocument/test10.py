from modules import ConvertPdftoText, ExtractText, TextReplacers, LineFilter, PdfReader, ConvertToCsv

def main(pdf_file, extract_file, pages):
    lines = []
    # PDFファイルをText配列に変換
    pdfreader = PdfReader(pdf_file, pages)
    lines = pdfreader.pdfplumber()

    for line in lines:
        print(line)

    # replacersを作成
    replacers = TextReplacers()
    replacers.add('－', '-')
    replacers.add('△', '-')
    replacers.add(',', '')
    replacers.add(',', '')

    # linefilterを作成
    # linefilter = LineFilter()
    # linefilter.add("決算短信")
    # linefilter.add("\(自")
    # linefilter.add("^\-\s\d+\s\-$")
    # linefilter.add("会計期間")
    # linefilter.add("（内訳）")
    # linefilter.add("累計期間")
    # linefilter.add("\d+年")

    lines = replacers.replace_all(lines)

    for line in lines:
        print(line)

    # filters_text = []
    # lines = linefilter.filter(lines)

    # for line in lines:
    #     print(line)

    extractText = ExtractText(extract_file, lines)
    extractText.process_lines()
    print(extractText.get_data())
    to_csv = ConvertToCsv(extractText.get_data())
    to_csv.to_csv()
    
if __name__ == "__main__":
# python実行時にファイル名を引数で指定してargsを使ってpdf変数として受け取る
    import sys
    pdf_file = sys.argv[1]
    extract_file = sys.argv[2]
    # if sys.argv[3]が定義されていれば
    pages = None
    if len(sys.argv) > 3:
        # sys.argv[3]を,でsplitし、int型に変換してpagesにいれる
        pages = [int(page) for page in sys.argv[3].split(',')]
    main(pdf_file, extract_file, pages)
