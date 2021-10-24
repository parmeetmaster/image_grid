
import 'package:logger/logger.dart';


extension mstrings on String {
  get printerror => {if (true) Logger().e(this)};

  get printwarn => {if (true) Logger().w(this)};

  get printinfo => {

        if (true)
          {
            Logger().i(this),
          }
      };

  get printwtf => {if (true) Logger().wtf(this)};

  get printverbose => {if (true) Logger().v(this)};
}
