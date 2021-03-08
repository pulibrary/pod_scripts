import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.Iterator;
import java.util.List;
import java.util.zip.GZIPInputStream;
import java.util.zip.GZIPOutputStream;
import org.marc4j.MarcXmlReader;
import org.marc4j.MarcXmlWriter;
import org.marc4j.MarcStreamWriter;
import org.marc4j.marc.DataField;
import org.marc4j.marc.Record;
import org.marc4j.marc.Subfield;
import org.marc4j.marc.VariableField;

/**
 * read marc xml files, remove records without oclc numbers, strip private notes (583) and package
 * for deposit in POD.
 * @author escowles
**/
public class filter {
  private static final SimpleDateFormat tsfmt = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss");
  private static final SimpleDateFormat dsfmt = new SimpleDateFormat("yyyyMMdd");
  private static final String dateStamp = dsfmt.format(new Date());

  public static void main(String[] args) throws Exception {
    int fileCount = 0;
    int included = 0;
    int skipped = 0;
    ArrayList<Record> records = new ArrayList();
    for (int i = 0; i < args.length; i++) {
      System.out.println(timestamp() + " reading " + args[i] + "...");
      MarcXmlReader in = new MarcXmlReader(new FileInputStream(args[i]));
      int includedInFile = 0;
      while (in.hasNext()) {
        Record record = in.next();

        // check if there is an oclc number in 035
        boolean oclc = false;
        DataField dataField = (DataField)record.getVariableField("035");
        if (dataField != null) {
          List ident = dataField.getSubfields();
          for (Iterator<Subfield> iterator = ident.iterator(); !oclc && iterator.hasNext(); ) {
            Subfield subfield = iterator.next();
            if (subfield.getData().indexOf("OCoLC") != -1)
              oclc = true;
          }
        }
        if (oclc) {
          // remove any private notes (583)
          DataField priv = (DataField)record.getVariableField("583");
          if (priv != null) {
            record.removeVariableField(priv);
          }
          records.add(record);
          included++;
          includedInFile++;
        } else {
          skipped++;
        }

        // in batches of 50k records, write to disk
        if (records.size() == 50000) {
          fileCount++;
          writeFile(fileCount, records);
          includedInFile = 0;
        }
      }
      if (includedInFile > 0) {
          fileCount++;
          writeFile(fileCount, records);
      }
    }

    System.out.println(timestamp() + " done, " + included + " records exported, " + skipped + " skipped");
  }

  private static String timestamp() {
    return tsfmt.format(new Date());
  }

  private static void writeFile(int fileCount, ArrayList<Record> records) throws Exception  {
    String fn = String.format("pod_files_java/pul_" + dateStamp + "_%04d.xml", fileCount);
    System.out.println(timestamp() + " writing " + fn + "...");
    MarcXmlWriter writer = new MarcXmlWriter(new FileOutputStream(fn), true);
    for (int x = 0; x < records.size(); x++) {
      writer.write(records.get(x));
    }
    writer.close();
    records.clear();
  }
}
