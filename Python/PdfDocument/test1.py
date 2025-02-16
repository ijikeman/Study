from modules import ConvertPdftoText, ExtractText, TextReplacers, LineFilter
import re
def main(pdf_file, extract_file):
    lines = []
    # PDFファイルをText配列に変換
    convertpdf = ConvertPdftoText(pdf_file)
    lines = convertpdf.convert()
    # for line in lines:
    #     print(line)

    # # replacersを作成
    # replacers = TextReplacers()
    # replacers.add('－', '-')
    # replacers.add('△', '-')
    # replacers.add(',', '')
    # replacers.add(',', '')

    # # linefilterを作成
    # linefilter = LineFilter()
    # # linefilter.add("期間")
    # linefilter.add("Evaluation")
    # linefilter.add("\-\s\d+\s\-")
    # # linefilter.add("計算書")
    # # linefilter.add("単位")
    # # linefilter.add("累計期間")
    # # linefilter.add("\d+年")

    # lines = replacers.replace_all(lines)
    # for line in lines:
    #     print(line)

    # filters_text = []
    # filters_text = linefilter.filter(lines)

    # # for line in filters_text:
    # #     print(line)

    # extractText = ExtractText(extract_file, filters_text)
    # extractText.process_lines()
    # # print(extractText.get_data())

if __name__ == "__main__":
# python実行時にファイル名を引数で指定してargsを使ってpdf変数として受け取る
    import sys
    pdf_file = sys.argv[1]
    extract_file = sys.argv[2]
    main(pdf_file, extract_file)
