using System;
using System.IO;
using System.Linq;
using System.Security.Cryptography;
using System.Text;

namespace calcmd5
{
    class Program
    {
        static void Main(string[] args)
        {
            if (!args.Any())
            {
                Console.WriteLine("Usage: calcmd5 [filename]");
                return;
            }

            var filename = args[0];
            if (!File.Exists(filename))
            {
                Console.WriteLine("Cannot find file {0}", filename);
                return;
            }

            var md5 = MD5.Create();
            var hash = md5.ComputeHash(File.ReadAllBytes(filename));
            var sb = new StringBuilder();
            foreach (var b in hash) sb.AppendFormat("{0:X2}", b);
            Console.WriteLine(sb);
        }
    }
}
