<?php
// Function to detect the encoding type of the argument
function guessEncoding ($text) { 
	return mb_detect_encoding(
		$text,
		mb_list_encodings(),
		true
	); 
}

// Function to convert the first argument to the encoding given by the second one.
function convertToUtf8 ($text, $encoding) {
	return iconv(
		$encoding,
		"UTF-8//TRANSLIT//IGNORE",
		$text
	);
}

// Main Script
if (count($argv) === 1) {
	$content = "";
	$encoding = "";
	$encodedContent = "";

	// Getting the STDIN
	$content = file_get_contents("php://stdin");
	// Detecting encoding
	$encoding = guessEncoding($content);
	// Converting to UTF-8
	$encodedContent = convertToUtf8($content, $encoding);
	
	//echo $encoding;
	echo $encodedContent;
	return 1;
} else {
	echo "PHP Guess encoding : bad argument !\nuse : cat <path_to_input_file> | php guess.php [> <path_to_output_file>]\n";
	return 0;
}

?>
