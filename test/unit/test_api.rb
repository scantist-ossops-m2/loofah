require "helper"

class UnitTestApi < Loofah::TestCase
  let(:html) { "<div>a</div>\n<div>b</div>" }
  let(:xml_fragment) { "<div>a</div>\n<div>b</div>" }
  let(:xml) { "<root>#{xml_fragment}</root>" }

  describe Loofah::HTML do
    it "creates documents" do
      doc = Loofah.document(html)
      assert_html_documentish doc
    end

    it "creates fragments" do
      doc = Loofah.fragment(html)
      assert_html_fragmentish doc
    end

    it "parses documents" do
      doc = Loofah::HTML::Document.parse(html)
      assert_html_documentish doc
    end

    it "parses document fragment" do
      doc = Loofah::HTML::DocumentFragment.parse(html)
      assert_html_fragmentish doc
    end

    it "scrubs documents" do
      doc = Loofah.document(html).scrub!(:strip)
      assert_html_documentish doc
    end

    it "scrubs fragments" do
      doc = Loofah.fragment(html).scrub!(:strip)
      assert_html_fragmentish doc
    end

    it "scrubs document nodes" do
      doc = Loofah.document(html)
      assert(node = doc.at_css("div"))
      node.scrub!(:strip)
    end

    it "scrubs fragment nodes" do
      doc = Loofah.fragment(html)
      assert(node = doc.at_css("div"))
      node.scrub!(:strip)
    end

    it "scrubs document nodesets" do
      doc = Loofah.document(html)
      assert(node_set = doc.css("div"))
      assert_instance_of Nokogiri::XML::NodeSet, node_set
      node_set.scrub!(:strip)
    end

    it "scrubs fragment nodesets" do
      doc = Loofah.fragment(html)
      assert(node_set = doc.css("div"))
      assert_instance_of Nokogiri::XML::NodeSet, node_set
      node_set.scrub!(:strip)
    end

    it "exposes serialize_root on Loofah::HTML::DocumentFragment" do
      doc = Loofah.fragment(html)
      assert_equal html, doc.serialize_root.to_html
    end

    it "exposes serialize_root on Loofah::HTML::Document" do
      doc = Loofah.document(html)
      assert_equal html, doc.serialize_root.children.to_html
    end
  end

  describe Loofah::XML do
    it "creates documents" do
      doc = Loofah.xml_document(xml)
      assert_xml_documentish doc
    end

    it "creates fragments" do
      doc = Loofah.xml_fragment(xml_fragment)
      assert_xml_fragmentish doc
    end

    it "parses documents" do
      doc = Loofah::XML::Document.parse(xml)
      assert_xml_documentish doc
    end

    it "parses document fragments" do
      doc = Loofah::XML::DocumentFragment.parse(xml_fragment)
      assert_xml_fragmentish doc
    end

    it "scrubs documents" do
      scrubber = Loofah::Scrubber.new { |node| }
      doc = Loofah.xml_document(xml).scrub!(scrubber)
      assert_xml_documentish doc
    end

    it "scrubs fragments" do
      scrubber = Loofah::Scrubber.new { |node| }
      doc = Loofah.xml_fragment(xml_fragment).scrub!(scrubber)
      assert_xml_fragmentish doc
    end

    it "scrubs document nodes" do
      doc = Loofah.xml_document(xml)
      assert(node = doc.at_css("div"))
      node.scrub!(:strip)
    end

    it "scrubs fragment nodes" do
      doc = Loofah.xml_fragment(xml)
      assert(node = doc.at_css("div"))
      node.scrub!(:strip)
    end

    it "scrubs document nodesets" do
      doc = Loofah.xml_document(xml)
      assert(node_set = doc.css("div"))
      assert_instance_of Nokogiri::XML::NodeSet, node_set
      node_set.scrub!(:strip)
    end
  end

  private

  def assert_html_documentish(doc)
    assert_kind_of Nokogiri::HTML4::Document, doc
    assert_kind_of Loofah::HTML::Document, doc
    assert_equal html, doc.xpath("/html/body").inner_html
  end

  def assert_html_fragmentish(doc)
    assert_kind_of Nokogiri::HTML4::DocumentFragment, doc
    assert_kind_of Loofah::HTML::DocumentFragment, doc
    assert_equal html, doc.inner_html
  end

  def assert_xml_documentish(doc)
    assert_kind_of Nokogiri::XML::Document, doc
    assert_kind_of Loofah::XML::Document, doc
    assert_equal xml, doc.root.to_xml
  end

  def assert_xml_fragmentish(doc)
    assert_kind_of Nokogiri::XML::DocumentFragment, doc
    assert_kind_of Loofah::XML::DocumentFragment, doc
    assert_equal xml_fragment, doc.children.to_xml
  end
end
