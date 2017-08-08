import configparser, glob, os

lang_config = configparser.ConfigParser()
lang_config.read('config/options.txt')
lang_setting = lang_config.get('Language', 'Language', fallback='en')

if not os.path.isfile("locale/{}.txt".format(lang_setting)):
    print("Invaild language: {}".format(lang_setting))
    lang_setting = "en"

lang_strs = {}

for file in glob.glob("locale/*.txt"):
    language_file = configparser.ConfigParser()
    language_file.read('{}'.format(file))
    lang_strs[file[7:-4]] = dict(language_file.items('language'))

class Lang():
    def bot_lang_control(string):
        try:
            lang_string = lang_strs[lang_setting][string]
        except:
            print("Missing translation '{}' in language '{}'".format(string, lang_setting))
            lang_string = string
        return lang_string
