# Jill: Package/Application Installer

![Jill Logo](jill_logo.png)

Jill is a simple command-line application installer that helps you create and install packages and executables easily. Whether you want to create a new package project, generate an executable, or install an existing package, Jill has got you covered.

## Usage

```bash
jill [options]
```

### Options
Specifies the operation to perform. You can choose from the following options:
  - `create-package`: Create a new package project.
  - `create-exec`: Generate an application.
  - `install`: Install an existing package.

### Installation
   1. To use Jill, make sure you have it installed. You can install it using your favorite Julia package manager. For example, with Julia's built-in package manager:

   ```bash
   julia -e 'using Pkg;Pkg.add(url="https://github.com/vdayanand/Jill.jl"); using Jill;Jill.install(dirname(dirname(Base.find_package("Jill))))'
   ```
   2. Add `~/.julia/bin` directory to the PATH variable
### Create a new package

   To create a new package, use the following command:

   ```bash
   jill create-package </path/to/package>
   ```

   Replace `/path/to/package` with the desired location for your new package project.


### Generate an application (package with bin/main.jl)

   To generate an executable, use the following command:

   ```bash
   jill create-exec  /path/to/package
   ```

   Replace `/path/to/package` with the path to your package project.


### **Install a application**

   To install an existing package, use the following command:

   ```bash
   jill install  /path/to/application
   ```

   Replace `/path/to/application` with the path to the package you want to install. Make sure "~/.julia/bin" is added to PATH variable

## Contributing

We welcome contributions to Jill! If you have any bug reports, feature requests, or would like to contribute to the development of Jill, please visit our [GitHub repository](https://github.com/vdayanand/jill).

## License

This project is licensed under the MIT License. See the [LICENSE](LICENSE) file for details.

---

**Note:** This README provides an overview of Jill's functionality. For detailed information and options, please refer to the built-in help:

```bash
jill --help
```

Thank you for using Jill! We hope it simplifies your application installation process. If you have any questions or need further assistance, feel free to reach out to us.

![Jill](jill.png)
