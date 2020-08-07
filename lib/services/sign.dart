import 'package:shared_preferences/shared_preferences.dart';

class Sign{
  static bool ok;
  isSignedBefore(userName) async{
    try {
     await getSharedPrefs(userName).then((value){
        print(value);
        if(value != null) {
          ok = true;
        }
        else{
          ok = false;
        }
       });
    }
    catch(e){
      print(e);
    }
    return ok;
  }

  doSign(userName,userPassword) async{
    try {
      this.isSignedBefore(userName).then((onValue){
        if(!onValue){
          this.putSharedPref(userName, userPassword);
          print("sign succed");
        }
        else{
          print("signed before");
        }
      });
    }
    catch (e){
      print(e);
    }
  }

  Future<String> getSharedPrefs(toGet) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString(toGet);
  }

  putSharedPref(key, value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
  clearSharedPred() async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.clear();
  }



}