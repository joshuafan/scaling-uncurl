# Contains methods to process input and output files for PLDA.

module PLDAUtils
export create_plda_file, parse_model_file, parse_result_file, parse_plda_input

# Generates an input file for PLDA from the matrix
function create_plda_file(matrix, file)
  open(file, "w") do f
    (r,c) = size(matrix)
    lines = IOBuffer()
    for i = 1:c
      for j = 1:r
        print(lines, "G$(lpad(j, 5, 0)) $(convert(Int64, matrix[j,i])) ")
      end
      print(lines, "\n")
      #takebuf_string(line)
      #push!(lines, line)
    end
    l = takebuf_string(lines)
    write(f, l)
  end
end

# Parses the "model file" outputted by PLDA into a
# (word x topic) (or gene x archetype) matrix.
function parse_model_file(model_file) 
  open(model_file) do f
    lines = readlines(f)
    num_lines = size(lines, 1)
    num_topics = size(split(lines[1]), 1) - 1
    word_topic = zeros((num_lines, num_topics))
    i = 1
    for line in lines
      word_topic[i, :] = float(split(line)[2:end])
      i += 1
    end
    return word_topic
  end
end


# Parse the "inference result" matrix outputed by PLDA into a 
# (topic x document) (or archetype x cell) matrix. 
function parse_result_file(result_file)
  document_topic = readdlm(result_file)
  return document_topic.'
end


# Given a PLDA input file (each line is a "document", with each word followed by
# its count), return a corresponding data matrix.
# NOTE: this is currently incorrect unless data is dense. I'll fix it ASAP.
function parse_plda_input(input_file)
  open(input_file) do f
    lines = readlines(f)
    num_lines = size(lines, 1)
    num_terms = size(split(lines[1]), 1) / 2
    matrix = zeros((num_lines, num_terms))
    ln = 1

    for line in lines
      row = []
      tokens = split(line)
      i = 2
      while i <= size(tokens, 1)
        push!(row, parse(Int, tokens[i]))
        i += 2
      end
      matrix[ln, :] = row
      ln += 1
    end
    return matrix
  end
end

end