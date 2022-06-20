import 'package:gsheets/gsheets.dart';

class GoogleSheetsApi {
  // create credentials
  static const _credentials = r'''
  {
  "type": "service_account",
  "project_id": "nimble-ally-353016",
  "private_key_id": "3c8ab2bda5b650538ea61397b6510e348ac63977",
  "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvAIBADANBgkqhkiG9w0BAQEFAASCBKYwggSiAgEAAoIBAQC2uhrqLp4YHJ5T\nZWCjZL1gxwgl+z/Kd1kpDnaD51qh/6oNCHit411N0ZmU32b6x6/moX6dOmbAhieA\nz0ewiBA6taMcSHTv6OB7u2q7bbNn6WyDjADiiXlVnj7ph2njW2L7IH968ZP4XwRc\n9+skxvV5Pqp+txV9wu031s2T6YniP9z1X0jxfMWIzG/bDahEgiLPnLerhin4op2Z\nTkFC4zsSR/Iz/iIbsncITCXpqhTZmJVAFspLZ7SwE/Tmp21lGUoaiSuMlYHDu5S3\n3svyTF0uhGsAHlJAGw7Xxtv3gQf3rA9/twYGw3IgvQRWfoVu70DwLpUQrV07CQZl\ny7tIsYyzAgMBAAECggEALYZgfkfvC4LVz2FKmmrW4+2ykgPu+LqTdC8uR960LfhM\nncKmjmw/Ksw1v2mJdqGZqZRCv1l1kDHcVbNO4SSFJptqb/l9aOhURX+EL/483H7D\nkmKnNcmaeUJb2kLqlsKF/psyJ6dYfmDt7Vu3Mgp/zh1WzQtAR3zxLSBPR7K/r6Zd\nSbacE7Gm1q21tPU6EaJdGCGxi1ICFwkQMlDU7vLdpBPcuWuDlDekuOUhM4SkyZSR\nA6Q4Hen5PdAu8KUb0+YF498EIqWtn1W22CZJhPvmxGXSRn5MG5DODKL/9dKsWYDe\nxSKOFeX6+6z4knNegHlWjPk5J/w3cHIEUDzSCeSPgQKBgQDvfJYRgeOCVN92sYdy\nv+vKcP7L82cFccQBjg1ni4DfhgZjaFfe8msU3jg8Hpo8X8b4/16iR1ZdlFxYBOaI\nvs8uZlHomfDU1S5vKtoLKK3+a2VsWKwrEP87JR186ubdp7npjmLTs2xvWTl6tFAB\n0WXuctpiff8WZO9f7vNYp/+q2QKBgQDDU5kWKUTPLRTKdf1hr8prBPRQnFihL8XJ\nZWuiJ6Vj172YHq315sBIMTK8YLttYzhr1YVsl4oEE+sW6Tc6TTTB3gg5w/SRwrlz\nmdt1+xP2ptPiPVMBhrTTHGGt7lUlOsrCYjGnN86n8Whg4NWR+ruCTeuejFM5d8FG\nGYIuF9/EawKBgDvVjtD0+Ni5R9Op60N6O/kqXh6qw5SSpfwVd7flHN+75qCzkzC6\ntJJUKwyqQLLQ4y+W7hfxZtyekqvTHZ4QvkbDfbd1rrwePym7NRsQoNguEPsO9IUW\nDA7E6ScqsV+z5jk6P+rQq0juq/PCVTL/FE6NF48AF9mKglwfoWEHKFORAoGAQq42\nU7dw8x0bvOY8wu2FN7WwRhiptRUe+1rxPKE2N/h9lAHdN1Y4DC0neeG3+mbl6wIw\nk1rEVhIKrn6dSPz0Zr6KplW8F0qXjtxWbFdzgD+Bk/mFbb7z2iIVQpBbZuNENsnY\n05IcrX6fOHtozXYAL0K0jiKvgq3cQDcTFvM1g9MCgYAl3WQcmRdeYDnWYwZvU9gq\nUldZjItFeVe60+hHuEcNu0fEvmtZfmuWj0Ct9+psXGE/f/T8BHhn2YgPzay4UI8Y\nktE0Sj4vjHEo7lcVlNRHqbTjEs8RG+ClrY1dC3JsXA2pDW17yhYlsep0+Qxjlh8x\nitnpech9h7i7KCr4ANiLTw==\n-----END PRIVATE KEY-----\n",
  "client_email": "flutter-gsheets-tutorial@nimble-ally-353016.iam.gserviceaccount.com",
  "client_id": "118280460651132981909",
  "auth_uri": "https://accounts.google.com/o/oauth2/auth",
  "token_uri": "https://oauth2.googleapis.com/token",
  "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
  "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/flutter-gsheets-tutorial%40nimble-ally-353016.iam.gserviceaccount.com"
  }
  ''';

  // set up & connect to the spreadsheet
  static final _spreadsheetId = '1JetFzUJEFVLQsGlAQ_lCtgVWWL1_b0MvsaTnx_IwNRM';
  static final _gsheets = GSheets(_credentials);
  static Worksheet? _worksheet;

  // some variables to keep track of..
  static int numberOfTransactions = 0;
  static List<List<dynamic>> currentTransactions = [];
  static bool loading = true;

  // initialise the spreadsheet!
  Future init() async {
    final ss = await _gsheets.spreadsheet(_spreadsheetId);
    _worksheet = ss.worksheetByTitle('Worksheet1');
    countRows();
  }

  // count the number of notes
  static Future countRows() async {
    while ((await _worksheet!.values
            .value(column: 1, row: numberOfTransactions + 1)) !=
        '') {
      numberOfTransactions++;
    }
    // now we know how many notes to load, now let's load them!
    loadTransactions();
  }

  // load existing notes from the spreadsheet
  static Future loadTransactions() async {
    if (_worksheet == null) return;

    for (int i = 1; i < numberOfTransactions; i++) {
      final String transactionName =
          await _worksheet!.values.value(column: 1, row: i + 1);
      final String transactionAmount =
          await _worksheet!.values.value(column: 2, row: i + 1);
      final String transactionType =
          await _worksheet!.values.value(column: 3, row: i + 1);

      if (currentTransactions.length < numberOfTransactions) {
        currentTransactions.add([
          transactionName,
          transactionAmount,
          transactionType,
        ]);
      }
    }
    print(currentTransactions);
    // this will stop the circular loading indicator
    loading = false;
  }

  // insert a new transaction
  static Future insert(String name, String amount, bool _isIncome) async {
    if (_worksheet == null) return;
    numberOfTransactions++;
    currentTransactions.add([
      name,
      amount,
      _isIncome == true ? 'thu' : 'chi',
    ]);
    await _worksheet!.values.appendRow([
      name,
      amount,
      _isIncome == true ? 'thu' : 'chi',
    ]);
  }

  // CALCULATE THE TOTAL INCOME!
  static double calculateIncome() {
    double totalIncome = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'thu') {
        totalIncome += double.parse(currentTransactions[i][1]);
      }
    }
    return totalIncome;
  }

  // CALCULATE THE TOTAL EXPENSE!
  static double calculateExpense() {
    double totalExpense = 0;
    for (int i = 0; i < currentTransactions.length; i++) {
      if (currentTransactions[i][2] == 'chi') {
        totalExpense += double.parse(currentTransactions[i][1]);
      }
    }
    return totalExpense;
  }
}
