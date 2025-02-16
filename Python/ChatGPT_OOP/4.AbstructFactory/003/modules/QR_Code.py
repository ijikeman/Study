import qrcode

class QR_Code:
    def __init__(self, url):
        self.url = url
    
    def create_qr(self):
        return qrcode.make(self.url)
