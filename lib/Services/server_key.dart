
import 'package:googleapis_auth/auth_io.dart';

class get_server_key {
  Future<String> server_token() async {
    final scopes = [
      'https://www.googleapis.com/auth/userinfo.email',
      'https://www.googleapis.com/auth/firebase.database',
      'https://www.googleapis.com/auth/firebase.messaging',
    ];
    final client = await clientViaServiceAccount(
        ServiceAccountCredentials.fromJson(
            {
              "type": "service_account",
              "project_id": "code-x-clock",
              "private_key_id": "48e70da5c1c1bc8aa1814fe55f5d2ab3245e45df",
              "private_key": "-----BEGIN PRIVATE KEY-----\nMIIEvwIBADANBgkqhkiG9w0BAQEFAASCBKkwggSlAgEAAoIBAQDkrl/+GZ/CXhp3\n/Sd+hbl0fuhoa3tAspJQu8LPfRUika3Np9m9XXJGeHCcd+953d44stXP4+NJIO1S\nSvPu+rlQI8Bpk7WLS9YnVNS6O8pU34M4ekhTu4UlSO4XZ/sW81wHL7SmQLshBki6\nwRWvrPfQR+P2RBzPXkhVzV0XFeshMDQ7/L/ZkBvw0lFWG13YMOaobcaYEDn61eaa\nHQheh137jPFVr0RMHH2EDbOebfMeXjdlSYNB7++TzAplHqBsbEeHLDYPOSnMiCC0\n9n4yvD2gYxkrdfNTJ2OXtcPRmnfVeQcG6kjVTF6usLTLWSXYPXkNQVZ2USm9QCFh\nbfSToGA5AgMBAAECggEABtSUhmzygiY4aSwVEWjiHLIrs+697DVJPIMXMwZb6r/q\nLpHcZZUUdDllt663Zu7zE8N3snFumQEURZh6h8FSZqvis+SXEBWQTHVysytVBEr2\nyumQHnwj4nS2s9lFvS5AqfBJV4voavialIVu5ePnNP/otbLcH2+D/pgXNzjO4JtX\nAu7ackXI06pc5zgWxKWtGUwcR7qtmmtL1RgyS6CKC56lvhS97icISUOJTwOAGnNP\n0AU0OEf2MtuOl7BCBBmf9lCLvO3HIjPOsoxLDeQZfZIqyhh0ciKK7lGNfaHGgiGs\nld1W9CxH76FzAE0MoBGeb/edOw4UszB6GlmJ8QvARwKBgQD+wny/pnAUY3XibOJG\nl6e+xfB+y7vMNYMxqnCPh0kQeZQBAB/7Y8Q67z1kwDGjB+RkpAn+mmayPGyloBro\ndge5U8Zx75xT6lKdLu1TcwpAYP5nTG7E01Qlc6i59p3wNWhJSRlGRrkIoDeO1JwI\n5i779UNFwl54oBqsJ3TCpyIfMwKBgQDly2KoGoIqisk7gQ77TMVY7iqu8Dvt/Kfg\nXoFUT6WpOnn4aaLmcd0jvn1zN9ge69peg6Yl+OwceVd87n21bkx75k1ecjKRwBVa\n74KluPCl3WtRQas9Ecat6OAkDW6uepLFx4D/OG1D48nz17zLt17JQuGYTHYGrGRC\nT4iOX55y4wKBgQCrHg+U20KlLzlbYS+Lown1RhcH0+jMfZUlowoAHiqhekhDc8YH\noTeJLnDaX433p7FtOBHOhf888QE5LpVkVwNRJEhC92LVqqrbEU4vozHblErNL7Wn\nVxtKHKnUXyYu1nC56POlFJPsi1FGCuDTyWj9q/wHu0qhU0kXIVl39bMhqQKBgQCK\niBtYxmpUZUi9U6eJfhW28BXRUsh+R4OZMr/66O0w4Szowh5PmLM9Ojh8vlzO/1at\nBeajG7aTz98bVNd6Ch2X0BYyatvrnAYDxUJYz+5bv+lTmig2b8H709lUQrjH/OMA\n0q4ErqrIc8mq9BNAKLK+2FASNX4ttb3XcAUd960ZCwKBgQDdsk09nYx97b/Gu/U9\nEityc9Dp9YMmd1W6W+XTLPF8n4YJZoX7IfJCUt/TtB4wLeXl8oE5quc5tlVlOUof\ncLludNJCJqRckUOblp4xsIqo+fJbe/uKCuFouoSlNx1qQQLIIK3QUqGXiY1I+Owv\nOHpv6ddKDGh/wawS+1bz551mtA==\n-----END PRIVATE KEY-----\n",
              "client_email": "firebase-adminsdk-fbsvc@code-x-clock.iam.gserviceaccount.com",
              "client_id": "109546127685044963552",
              "auth_uri": "https://accounts.google.com/o/oauth2/auth",
              "token_uri": "https://oauth2.googleapis.com/token",
              "auth_provider_x509_cert_url": "https://www.googleapis.com/oauth2/v1/certs",
              "client_x509_cert_url": "https://www.googleapis.com/robot/v1/metadata/x509/firebase-adminsdk-fbsvc%40code-x-clock.iam.gserviceaccount.com",
              "universe_domain": "googleapis.com"
            }
        ),
        scopes);
    final accessserverkey = client.credentials.accessToken.data;
    return accessserverkey;
  }
}
