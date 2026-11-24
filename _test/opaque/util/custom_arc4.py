# Custom process `util.custom_arc4.custom_arc4(key)` for security/gdata_quarantine.ksy
# and security/windef_{entries,resources,resource_data}.ksy: plain RC4 with the
# key the spec passes (ksc hands it over as bytes).


class CustomArc4(object):
    def __init__(self, key):
        key = bytes(key)
        s = list(range(256))
        j = 0
        for i in range(256):
            j = (j + s[i] + key[i % len(key)]) & 0xFF
            s[i], s[j] = s[j], s[i]
        self._s = s

    def decode(self, data):
        s = list(self._s)  # every field starts from the key schedule
        i = j = 0
        out = bytearray(len(data))
        for n, b in enumerate(data):
            i = (i + 1) & 0xFF
            j = (j + s[i]) & 0xFF
            s[i], s[j] = s[j], s[i]
            out[n] = b ^ s[(s[i] + s[j]) & 0xFF]
        return bytes(out)
