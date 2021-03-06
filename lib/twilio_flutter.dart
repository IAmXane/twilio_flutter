library twilio_flutter;

import 'package:meta/meta.dart';
import 'package:twilio_flutter/models/sms.dart';
import 'dart:convert';
import 'package:twilio_flutter/services/network.dart';

class TwilioFlutter {
  String _twilioNumber;
  String _toNumber, _messageBody;
  NetworkHelper _networkHelper = NetworkHelper();
  Map<String, String> _auth = Map<String, String>();
  String _url;
  final _baseUri = "https://api.twilio.com";
  String _version = '2010-04-01';
  List<SMS> _smsList = [];
  SMS _sms = SMS();

  TwilioFlutter(
      {@required String accountSid,
      @required String authToken,
      @required String twilioNumber}) {
    this._auth['accountSid'] = accountSid;
    this._auth['authToken'] = authToken;
    this._auth['twilioNumber'] = this._twilioNumber = twilioNumber;
    this._auth['baseUri'] = _baseUri;
    this._auth['cred'] = '$accountSid:$authToken';
    this._url = '$_baseUri/$_version/Accounts/$accountSid/Messages.json';
  }

  Future sendSMS(
      {@required String toNumber, @required String messageBody}) async {
    String cred = this._auth['cred'];
    this._toNumber = toNumber;
    this._messageBody = messageBody;
    var bytes = utf8.encode(cred);
    var base64Str = base64.encode(bytes);

    var headers = {
      'Authorization': 'Basic $base64Str',
      'Accept': 'application/json'
    };
    var body = {
      'From': this._twilioNumber,
      'To': this._toNumber,
      'Body': this._messageBody
    };

    _networkHelper.postMessageRequest(_url, headers, body);
  }

  changeTwilioNumber(String twilioNumber) {
    this._twilioNumber = twilioNumber;
  }

  sendWhatsApp(
      {@required String toNumber, @required String messageBody}) async {
    String cred = this._auth['cred'];
    this._toNumber = toNumber;
    this._messageBody = messageBody;
    var bytes = utf8.encode(cred);
    var base64Str = base64.encode(bytes);
    var headers = {
      'Authorization': 'Basic $base64Str',
      'Accept': 'application/json'
    };
    var body = {
      'From': 'whatsapp:' + this._twilioNumber,
      'To': 'whatsapp:' + this._toNumber,
      'Body': this._messageBody
    };

    _networkHelper.postMessageRequest(_url, headers, body);
  }

  getSmsList() async {
    var getUri = 'https://' +
        this._auth['accountSid'] +
        ':' +
        this._auth['authToken'] +
        '@api.twilio.com/' +
        _version +
        '/Accounts/' +
        this._auth['accountSid'] +
        '/Messages.json';
    print(getUri);
    this._smsList = await _sms.getSMSList(getUri);
  }

  getSMS(var messageSid) {
    bool found = false;
    for (var sms in this._smsList) {
      if (sms.messageSid == messageSid) {
        print('Message body : ' + sms.body);
        print('To : ' + sms.to);
        print('Sms status : ' + sms.status);
        print('Message URL :' + 'https://api.twilio.com' + sms.messageURL);
        found = true;
      }
    }
    if (!found) print('Not Found');
  }
}
